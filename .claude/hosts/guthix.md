# guthix — k3s single-node Kubernetes cluster

- **SSH:** `rudi@guthix.rudsvar.xyz` (192.168.10.169, static)
- **Hardware:** Intel Core i7-4790 (8 threads), 16 GiB DDR3. Disks: `sda` ~112 GB (root), `sdb` ~932 GB (`/mnt/backup`, borg targets).
- **OS:** Arch Linux rolling. No Docker — container runtime is containerd (k3s).
- **k3s:** single-node, control-plane + worker. Check version with `k3s --version`. Config: `/etc/rancher/k3s/config.yaml`.
- **Storage:** `local-path` provisioner (default). PVCs land at `/var/lib/rancher/k3s/storage/`.
- **GitOps:** ArgoCD manages all workloads. Repo: `ssh://git@forgejo.cruor.rudsvar.xyz:2222/rudi/homelab-k8s.git` (app-of-apps in `apps/`). **Do not use `~/services/`** — there isn't one. Push to homelab-k8s → ArgoCD syncs.

## Workloads

Check live state with `kubectl get ns` and `kubectl get pods -A`. The `homelab-k8s` repo is the source of truth for what should be running.

## Ingress

Traefik handles ingress + TLS (Cloudflare DNS challenge). Check routes: `kubectl get ingressroute -A`. Pattern: `<app>.guthix.rudsvar.xyz`.

## Forgejo runner

Deployment in `forgejo-runner` namespace. DinD sidecar setup — runner uses the DinD socket. Key behaviour:
- `network: ""` — per-job Docker bridge network; service containers reachable by name (e.g. `DB_HOST: postgres`), not `127.0.0.1`. Required for concurrent jobs without port conflicts.
- `capacity: 2` — two jobs concurrently.
- Config is a static `config.yml` in the `runner-entrypoint` ConfigMap with `__POD_IP__` substituted at startup via Downward API.

**Do not use `network: "host"`** — causes port conflicts between concurrent jobs.

After ConfigMap changes: `kubectl rollout restart deployment/forgejo-runner -n forgejo-runner` (ArgoCD syncs the ConfigMap but won't restart the pod).

## Backups

Two Borg repos on `/mnt/backup` (sdb), separate:

- **`/mnt/backup/borg`** — per-DB `pg_dump` archives, written by in-cluster CronJobs. Check schedules: `kubectl get cronjob -A`. Encrypted (passphrase in `borg-passphrase` k8s secret in `homelab` ns).
- **`/mnt/backup/borg-cluster`** — nightly cold snapshot of `/var/lib/rancher/k3s` + `/etc/rancher/k3s` (+ `/etc/systemd/system/k3s.service.d` if present). Captures all PVCs atomically while k3s is stopped. **Unencrypted** (`--encryption=none`). Retention: 7 daily / 4 weekly / 6 monthly.

### Cold-backup mechanism

- Script: `/usr/local/bin/k3s-cold-backup.sh` (stops k3s → borg create → prune → compact → starts k3s).
- Unit + timer: `/etc/systemd/system/k3s-cold-backup.{service,timer}`. Timer fires `03:00` daily, `Persistent=true`, 5min randomized delay.
- **Downtime window ~5–10 min nightly** (mostly pod restart, not borg). All `*.guthix.rudsvar.xyz` services unreachable during it.
- Logs: `journalctl -u k3s-cold-backup`.
- Manual run: `sudo systemctl start k3s-cold-backup.service` (will incur the downtime — don't run mid-day without warning).
- List archives: `sudo borg list /mnt/backup/borg-cluster`.

### Restore (cold-backup)

`/usr/local/bin/k3s-cold-restore.sh` does the full-host restore. Destructive: wipes live `/var/lib/rancher/k3s` + `/etc/rancher/k3s` before extract, prompts for `restore` confirmation.

```sh
sudo k3s-cold-restore.sh                      # interactive picker
sudo k3s-cold-restore.sh latest               # most recent
sudo k3s-cold-restore.sh cluster-2026-05-28   # specific archive
```

For a *single* PVC (e.g. one corrupted Postgres dir): scale the consumer to 0, `borg extract` only the `var/lib/rancher/k3s/storage/pvc-<uuid>` path to a scratch dir, rsync over, scale back up. Don't use the full restore script — it takes the whole cluster down.

Inspect without extracting: `sudo borg mount /mnt/backup/borg-cluster::<archive> /mnt/x`.

## Careful with

- `PasswordAuthentication no`, `PermitRootLogin no`
- `/var/run/docker.sock` exists (orphaned from a previous Docker install) — ignore it, k3s uses containerd.
- Dotfiles via `~/.cfg` bare repo; `conf` alias fish-only.
