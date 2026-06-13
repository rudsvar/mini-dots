# fumus — public VPS (Hetzner, Germany)

- **SSH:** `rudi@fumus.rudsvar.xyz` (public IP `116.203.114.150`; also reachable via WireGuard `wgcruor` at `10.9.0.3`).
- **Hardware:** Hetzner KVM, 2 vCPU / 3.7 GiB RAM / 38 GB disk. **No swap.**
- **OS:** Ubuntu 24.04 LTS.
- **Role:** public-facing edge. Check `docker compose ls` or `ls ~/services/` for running services.
- **Services:** `~/services/<service>/<service>.yml` — one per service. Secrets in per-service `.env` files (not in git). Shared network: `fumus_traefik_net` (external, created by traefik stack).
- **Deploy:** `cd ~/services/<service> && docker compose -f <service>.yml up -d`

## Running services (check `docker compose ls` for current state)

- **traefik** — reverse proxy, ports 80/443, Cloudflare DNS challenge TLS (`*.rudsvar.xyz`, `*.fumus.rudsvar.xyz`)
- **registry** — Docker registry v2 at `registry.fumus.rudsvar.xyz` (WireGuard/VPN-only via DNS; `*.fumus.rudsvar.xyz` → `10.9.0.3`)
- **lift** — fitness tracker at `fits.rudsvar.xyz` (**DNS A record still needed**: `fits.rudsvar.xyz` → `116.203.114.150`); CI auto-deploys from Forgejo on push to main. DB is internal (`lift_internal` network only, not on `fumus_traefik_net`).
- api, landing, url-shortener, beszel, terraria, factorio — see compose files

## WireGuard

- Interface: `wgcruor`, IP `10.9.0.3/24`
- `*.fumus.rudsvar.xyz` in Cloudflare DNS resolves to `10.9.0.3` — these domains are VPN-gated by DNS
- `10.9.0.1` is reachable (cruor's WireGuard peer)

## Careful with

- Anything on 80/443 — production surface. **Never add Traefik labels to expose a service without confirming first.**
- No swap — watch memory during large builds; prefer building elsewhere and shipping via `docker save | gzip | ssh ... gunzip | docker load`.
- Game saves in `~/services/terraria/data/` and `~/services/factorio/data/` — treat as precious.
- Data dirs under `~/services/` are bind-mounted — don't remove service dirs without checking for data.
- lift DB data lives at `~/services/lift/data/postgres` — treat as precious.
