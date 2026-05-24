# pi — Raspberry Pi (home LAN)

- **SSH:** `rudi@pi.rudsvar.xyz` (also `raspberrypi.local` on LAN).
- **Hardware:** Raspberry Pi, Cortex-A53 (armv7), ~921 MiB RAM.
- **OS:** Raspbian 11 bullseye (approaching EOL — don't surprise-upgrade).
- **Disks:** SD card, ~15 GB root. Don't write bulk data here.
- **Role:** LAN presence, WireGuard, monitoring agent. Check `docker ps` and `systemctl list-units --state=running` for what's active.
- **Services:** `~/services/` — plain docker-compose v1.25 (no Swarm; armv7 image support too limited).
- **Note:** `cloudflare/cloudflared` Docker image has no armv7 manifest — cannot containerize on this host.
- **Careful with:**
  - WireGuard config — this is how fumus is reachable as `fumus.lan`.
  - SD card space.
