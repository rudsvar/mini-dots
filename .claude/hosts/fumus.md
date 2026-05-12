# fumus — public VPS (Hetzner, Germany)

- **SSH:** `rudi@fumus.rudsvar.xyz` (also `fumus.lan` / `10.200.160.3` over WireGuard; no mDNS).
- **Hardware:** Hetzner KVM vServer, 2 vCPU / 3.7 GiB RAM / 38 GB disk. **No swap.**
- **OS:** Ubuntu 24.04 LTS.
- **Role:** public-facing edge. Hosts external-facing services.
- **Compose files:** `~/services/<service>/<service>.yml` — one per service, tracked in `rudsvar/fumus` dotfiles repo. Secrets in per-service `.env` files (not in git). Shared network: `fumus_traefik_net` (external, created by traefik stack).
- **Deploy:** `cd ~/services/<service> && docker compose -f <service>.yml up -d`
- **Source code:** `landing` source (Dockerfile + HTML/nginx) lives in `~/services/landing/`. `api` and `url-shortener` are locally built images (`api:latest`, `url-shortener:latest`) with no source on fumus — source is elsewhere.
- **Running services:** Traefik v2.11, api (Director Go app + Postgres 16), landing, url-shortener, Factorio, Terraria. Plain Compose (not Swarm).
- **Stopped/disabled:** beszel and beszel-agent-cruor (dirs + data present, not running).
- **Data dirs (bind-mounted):** `~/services/traefik/letsencrypt/`, `~/services/terraria/data/`, `~/services/factorio/data/`, `~/services/beszel-agent-cruor/data/`, `~/services/db-backup/data/` (leftover, no compose file) — do not remove these.
- **Game backups:** hourly cron — scripts referenced at `~/fumus/{terraria,factorio}-backup.sh` but `~/fumus/` does not exist; backups are likely broken and need investigation.
- **Careful with:**
  - Anything on 80/443 — it's the production surface.
  - **Never add Traefik labels to expose a service without confirming first.**
  - No swap — watch memory during large builds.
  - Game saves in `~/services/terraria/data/` and `~/services/factorio/data/` — treat as precious.
