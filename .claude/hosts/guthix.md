# guthix

**Role:** k3s single-node Kubernetes cluster (control-plane + worker)
**OS:** Arch Linux (kernel 6.18.29-1-lts)
**SSH:** `rudi@guthix.rudsvar.xyz` (192.168.10.169, static)
**Network:** WiFi (wlan0), static IP via systemd-networkd

## Hardware

- CPU: Intel Core i7-4790 @ 3.60GHz (8 threads)
- RAM: 16 GiB DDR3 @ 1867 MT/s (6.4 GiB used, 9.2 GiB available)
- Disk: `sda` 111.8 GB — sda1 `/boot` (1G), sda2 swap (4G), sda3 `/` ext4 (105G, ~55% used)
- Disk: `sdb` 931.5 GB — sdb1 `/mnt/backup` ext4 (borg backups)

## Kubernetes (k3s)

- **k3s** v1.35.4+k3s1, single-node, control-plane role
- **Container runtime:** containerd 2.2.3-k3s1 — **no Docker installed**
- `servicelb` disabled (Traefik handles LoadBalancer via MetalLB-style assignment)
- **kubectl** available in PATH unprivileged
- **Storage:** `local-path` provisioner (default), PVCs backed by local disk
- **GitOps:** ArgoCD manages all workloads via `ssh://git@forgejo.cruor.rudsvar.xyz:2222/rudi/homelab-k8s.git` (app-of-apps, root in `apps/`)
- k3s config: `/etc/rancher/k3s/config.yaml`

## Deploying / changing workloads

**Do NOT use `~/services/`** — there is no services dir on guthix. All workloads are k8s-managed.

To deploy or change anything: push to the `homelab-k8s` repo on Forgejo → ArgoCD syncs automatically.

## Running namespaces / workloads

| Namespace      | What's in it                                                        |
|----------------|---------------------------------------------------------------------|
| argocd         | ArgoCD app-of-apps GitOps controller                                |
| beszel         | beszel-agent DaemonSet (reports to beszel on cruor)                 |
| elk            | Elasticsearch (20Gi PVC), Kibana, Filebeat                          |
| forgejo-runner | Forgejo CI runner (DinD sidecar, capacity 2) — see below            |
| host-metrics   | node-exporter, smartctl-exporter DaemonSets                         |
| infisical      | Infisical + Postgres (5Gi PVC) + Redis; daily backup CronJob        |
| kube-system    | Traefik (LB on :80/:443/:5432), CoreDNS, metrics-server, local-path |
| ledger         | ledger app + Postgres (1Gi PVC); daily backup CronJob               |
| pgbouncer      | PgBouncer connection pooler (userlist: things, ledger, postgres)     |
| postgres       | Standalone shared Postgres (5Gi PVC); admin password in secret      |
| rabbitmq       | RabbitMQ + management UI (2Gi PVC); limits via ConfigMap            |
| things         | things app + Postgres (1Gi PVC); daily backup CronJob               |
| backup         | Backup tooling                                                       |

## Ingress (Traefik IngressRoutes)

- `argocd.guthix.rudsvar.xyz` — ArgoCD UI
- `kibana.guthix.rudsvar.xyz` — Kibana
- `infisical.guthix.rudsvar.xyz` — Infisical
- `ledger.guthix.rudsvar.xyz` — Ledger prod
- `rabbitmq.guthix.rudsvar.xyz` — RabbitMQ management UI
- `things.guthix.rudsvar.xyz` — Things
- TCP IngressRoute on port 5432 — postgres via pgbouncer

## Secrets (notable)

- `kube-system/cloudflare-api-token` — Cloudflare DNS token (for Traefik TLS)
- `*/forgejo-registry` — docker pull secret (in each app namespace)
- `*/borg-passphrase` — borg backup passphrase (infisical, ledger, things)
- `postgres/postgres-credentials` — standalone postgres admin password
- `rabbitmq/rabbitmq-credentials` — RabbitMQ admin credentials

## Backups

- `/mnt/backup` (sdb1, 931.5 GB ext4) — borg backup target
- CronJobs at 02:00–02:20 daily: `backup-infisical`, `backup-ledger`, `backup-things`

## SSH keys

- glacies → guthix: `~/.ssh/guthix`
- cruor → guthix: `~/.ssh/guthix` on cruor

## Forgejo runner

Runs as a k8s Deployment in the `forgejo-runner` namespace. Pod has two containers:
- `runner` — `data.forgejo.org/forgejo/runner:12`, capacity 2, labels `ubuntu-latest` / `ubuntu-22.04` / `debian-latest`
- `dind` — `docker:27-dind` sidecar; both containers share `/var/run` via emptyDir so the runner uses the DinD socket

Runner config is a static `config.yml` embedded in the `runner-entrypoint` ConfigMap. On startup the entrypoint substitutes `__POD_IP__` with the actual pod IP (injected via Downward API) and writes it to `/data/config.yml`. Key settings:
- `network: ""` — runner creates a per-job Docker bridge network inside DinD; service containers (e.g. postgres) are reachable by service name (e.g. `postgres`), not `127.0.0.1`. This is what allows concurrent jobs without port conflicts.
- `docker_host: "automount"` — Docker socket is mounted into job containers
- `capacity: 2` — two jobs run concurrently
- Cache dir: `/data/actcache`; cache server bound to the pod IP so job containers inside DinD can reach it

**Important:** CI workflows must use the service name as `DB_HOST`, not `127.0.0.1`. See things/ledger `.forgejo/workflows/ci.yml` for the pattern.

**Do not use `network: "host"`** — it causes port 5432 conflicts between concurrent jobs sharing the same DinD daemon.

To change runner config: update the `config.yml` key in the `runner-entrypoint` ConfigMap in `homelab-k8s`, push, then `kubectl rollout restart deployment/forgejo-runner -n forgejo-runner` on guthix (ArgoCD syncs the ConfigMap but won't restart the pod automatically).

## Notes

- `PasswordAuthentication no`, `PermitRootLogin no`
- Dotfiles tracked via `~/.cfg` bare repo; `conf` alias fish-only
- Docker socket `/var/run/docker.sock` exists (orphaned daemon from previous install, no binary) — ignore it, k3s uses containerd
