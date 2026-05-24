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

Borg to `/mnt/backup` (sdb). CronJobs run nightly — check schedules with `kubectl get cronjob -A`.

## Careful with

- `PasswordAuthentication no`, `PermitRootLogin no`
- `/var/run/docker.sock` exists (orphaned from a previous Docker install) — ignore it, k3s uses containerd.
- Dotfiles via `~/.cfg` bare repo; `conf` alias fish-only.
