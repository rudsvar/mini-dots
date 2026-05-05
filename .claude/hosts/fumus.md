# fumus — public VPS (Hetzner, Germany)

- **SSH:** `rudi@fumus.rudsvar.xyz` (also `fumus.lan` / `10.200.160.3` over WireGuard; no mDNS).
- **Hardware:** Hetzner KVM vServer, 2 vCPU / 3.7 GiB RAM / 38 GB disk. **No swap.**
- **OS:** Ubuntu 24.04 LTS.
- **Role:** public-facing edge. Hosts external-facing services.
- **Compose files:** `~/services/<service>/<service>.yml` — one per service, tracked in `rudsvar/fumus` dotfiles repo. Secrets in per-service `.env` files (not in git). Shared network: `traefik_traefik_net` (external, created by traefik stack).
- **Deploy:** `cd ~/services/<service> && docker compose -f <service>.yml up -d`
- **Source code:** `~/fumus/<service>/` — Dockerfiles and source for custom services (api, landing, url-shortener, db-backup).
- **Stack:** Traefik v2.11, Postgres 16, api, landing, url-shortener, db-backup, Arcane, Beszel + agent, beszel-agent-cruor (reports to cruor hub), Factorio, Terraria. Plain Compose (not Swarm).
- **Data dirs (bind-mounted):** `~/services/traefik/letsencrypt/`, `~/services/terraria/data/`, `~/services/factorio/data/`, `~/services/arcane/data/`, `~/services/db-backup/data/`, `~/services/beszel-agent-cruor/data/` — do not remove these.
- **Game backups:** hourly borg backup via cron — scripts at `~/fumus/{terraria,factorio}-backup.sh`, repos at `~/services/db-backup/data/{terraria,factorio}-borg`.
- **Careful with:**
  - Anything on 80/443 — it's the production surface.
  - **Never add Traefik labels to expose a service without confirming first.**
  - `db-backup` writes real backups; don't interrupt or clobber its volumes.
  - No swap — watch memory during large builds.
  - Game saves in `~/services/terraria/data/` and `~/services/factorio/data/` — treat as precious.
