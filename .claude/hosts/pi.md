# pi — Raspberry Pi (home LAN)

- **SSH:** `rudi@pi.rudsvar.xyz` (also `raspberrypi.local` on LAN).
- **Hardware:** Raspberry Pi, Cortex-A53 (armv7), **921 MiB RAM** + 99 MiB swap.
- **OS:** Raspbian 11 bullseye (approaching EOL — plan, don't surprise-upgrade).
- **Disks:** SD card `/` 15 GB.
- **Role (current):** LAN presence, Traefik reverse proxy, WireGuard, Beszel monitoring agent.
- **Services root:** `~/services/` — plain docker-compose v1.25 (no Swarm; armv7 image support too limited).
- **Running containers:** Beszel agent, node-exporter.
- **Systemd services:** cloudflared (SSH tunnel via cruor's connector), fail2ban, pihole-FTL (running but not actively used — AdGuard on cruor is the live LAN DNS).
- **Removed/migrated:** rubot (removed), samba (removed), ddclient (removed — DDNS now on cruor), cloudflared systemd (disabled — connector moved to cruor), k3s (unit removed), honeypot (unit removed), portainer/traefik/postgres/wireguard (removed — all on cruor).
- **Note:** `cloudflare/cloudflared` Docker image has no armv7 manifest — cannot containerize on this host.
- **Careful with:**
  - SD card free space — don't write bulk data here.
  - WireGuard config (this is how I reach fumus over `.lan`).
