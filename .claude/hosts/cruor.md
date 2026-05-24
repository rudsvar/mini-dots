# cruor — LAN workhorse (homelab server)

- **SSH:** `rudi@cruor.rudsvar.xyz`
- **Local mount:** `/mnt/cruor` — SSHFS automount from glacies, mounts on access. Edit files directly via this path instead of SSHing in.
- **Hardware:** MSI MS-7751, Intel i7-3770K (2012), 8 GiB DDR3 @ 1600 MT/s + 3.8 GiB swap. Has Wi-Fi. Has a monitor attached — runs a GUI (sway).
- **OS:** Arch Linux rolling.
- **Disks:** `/` ext4 **109 GB** (tight), `/mnt/1tbhdd` **ZFS pool (`tank`) 880 GB** (bulk).
- **Role:** Docker Swarm host for the self-hosted stack. Some services run as plain `docker compose` instead of Swarm stacks where Swarm overlay networking is a poor fit (e.g. the Forgejo runner needs to be on the same bridge as its job containers).
- **Stacks live at:** `~/services/` on cruor — **versioned, source of truth.** Deploy from there. Do **not** create stacks under `~/git/stacks/` or other ad-hoc paths.
- **Version control:** `~/services/` and other cruor-specific files are tracked in `~/.cruor` bare repo. Shared dotfiles (fish, nvim, etc.) come from `~/.cfg` (mini-dots). To commit cruor-specific files: `git --git-dir="$HOME/.cruor" --work-tree="$HOME" add -f <file>` and commit. Do **not** `git init` inside a service dir.
- **GPU:** NVIDIA GeForce GTX 980 (Maxwell, sm_52, 4 GiB VRAM). NVIDIA driver 580.xx (legacy Maxwell branch). CUDA 13 dropped Maxwell support — GPU uses **Vulkan** for ollama.
- **Ollama:** Runs as native systemd service (not Docker). Models at `/var/lib/ollama/`. Override at `/etc/systemd/system/ollama.service.d/override.conf`.
- **Forgejo runner:** runs as plain compose (`~/services/forgejo/runner.yml`, `docker compose -f runner.yml up -d`), NOT as a Swarm service. Reason: runner must be on `runner-net` bridge (172.19.0.0/16) so its cache server is reachable from CI job containers. The main Forgejo app remains a Swarm stack (`forgejo.yml`).
- **Services:** Immich (+ Postgres/Redis), Jellyfin, Sonarr / Radarr / Bazarr / Prowlarr, qBittorrent, Jellyseerr, Flaresolverr, Romm (+ MariaDB), Home Assistant, Grafana + Prometheus, **AdGuard (LAN DNS, 192.168.10.126)**, WireGuard (`wg-easy`), Traefik v3, Homepage, Open-WebUI + Ollama, Arcane, Factorio, rubot, ofelia (cron), llm-wiki, grand-exchange, **cloudflared** (Cloudflare tunnel connector, `~/services/cloudflared/`), **cloudflare-ddns** (updates `nex.rudsvar.xyz` A record every 5 min, `~/services/cloudflare-ddns/`).
- **Custom app source locations:**
  - `grand-exchange`: source at `github.com/rudsvar/grand-exchange`, clone at `~/services/grand-exchange/app/`. No forgejo mirror yet — push to GitHub AND add forgejo remote to get CI builds. Makefile uses `cross` for arm builds.
  - `ge-ui`: source lives only in `~/services/ge-ui/` (no git repo). No CI pipeline. Push to forgejo registry manually until a repo + pipeline is set up.
  - Both need pushing to two places until a GitHub→Forgejo mirror or unified pipeline is arranged.
- **Backups:**
  - `sanoid.timer` — local ZFS snapshots on `tank` every 15 min.
  - `borgmatic.timer` (system, 02:00) — dumps immich + grand-exchange DBs via `docker exec`, archives immich library + GE data + dumps to Hetzner storage box (`u587634-sub1`, repo `./borgmatic`). Config at `/etc/borgmatic/config.yaml`; reference copy + SSH public key in `~/.config/borgmatic/` (dotfiles). Private key at `/root/.ssh/borgmatic_borg_key`, passphrase at `/root/.borgmatic-passphrase`.
  - Old `borg-nightly` / `backup-daily` units superseded — pending cleanup of unit files, scripts, and old storage box repos (`immich`, `grand-exchange`).
- **Disk discipline (IMPORTANT):**
  - Run `df -h` on cruor before any non-trivial write.
  - Put container volumes, build caches, DB dumps, downloads on `/mnt/1tbhdd`, not `/`.
  - `/mnt/1tbhdd` is a ZFS pool — `zfs destroy` is subject to the hard-rule safeguards in global CLAUDE.md.
- **Network — homelab machines:**

  | Host    | Role                              | SSH                                   |
  |---------|-----------------------------------|---------------------------------------|
  | glacies | Main workstation (Arch, you here) | local only                            |
  | cruor   | LAN Docker Swarm workhorse        | `cruor` / `cruor.rudsvar.xyz`         |
  | fumus   | Public VPS (Hetzner, DE)          | `fumus.rudsvar.xyz` / `fumus.lan`     |
  | pi      | RPi — WireGuard + monitoring      | `pi.rudsvar.xyz`                      |
  | umbra   | Phone                             | not SSH-managed                       |

  - All hosts reachable via Cloudflare tunnels; `*.rudsvar.xyz` DNS is wildcarded through Cloudflare.
  - LAN DNS: AdGuard on cruor at `192.168.10.126`.
  - cruor can SSH to fumus and pi using the above aliases/hostnames.

- **Careful with:**
  - **Immich DB + photo library** — irreplaceable. Do not touch its volumes.
  - `/mnt/1tbhdd` holds bulk media + likely Immich originals.
  - AdGuard outage = no DNS on the LAN.
  - Rolling release: never `pacman -Syu` unprompted.
