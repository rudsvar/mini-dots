# fumus — public VPS (Hetzner, Germany)

- **SSH:** `rudi@fumus.rudsvar.xyz` (also `fumus.lan` / `10.200.160.3` over WireGuard).
- **Hardware:** Hetzner KVM, 2 vCPU / 3.7 GiB RAM / 38 GB disk. **No swap.**
- **OS:** Ubuntu 24.04 LTS.
- **Role:** public-facing edge. Check `docker compose ls` or `ls ~/services/` for running services.
- **Services:** `~/services/<service>/<service>.yml` — one per service, tracked in the fumus dotfiles repo. Secrets in per-service `.env` files (not in git). Shared network: `fumus_traefik_net` (external, created by traefik stack).
- **Deploy:** `cd ~/services/<service> && docker compose -f <service>.yml up -d`

## Careful with

- Anything on 80/443 — production surface. **Never add Traefik labels to expose a service without confirming first.**
- No swap — watch memory during large builds.
- Game saves in `~/services/terraria/data/` and `~/services/factorio/data/` — treat as precious.
- Data dirs under `~/services/` are bind-mounted — don't remove service dirs without checking for data.
