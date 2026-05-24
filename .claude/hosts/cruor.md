# cruor — LAN workhorse (homelab server)

- **SSH:** `rudi@cruor.rudsvar.xyz`
- **Local mount:** `/mnt/cruor` — SSHFS automount from glacies, mounts on access. Edit files directly via this path instead of SSHing in.
- **Hardware:** MSI MS-7751, Intel i7-3770K (2012), 8 GiB DDR3. Has Wi-Fi. Monitor attached — runs a GUI (sway).
- **OS:** Arch Linux rolling.
- **Disks:** `/` ext4 ~109 GB (tight — run `df -h` before non-trivial writes), `/mnt/1tbhdd` ZFS pool (`tank`, bulk storage).
- **Role:** Docker Swarm manager for the self-hosted stack. Some services run as plain `docker compose` where Swarm overlay networking is a poor fit.
- **Services:** `~/services/` — source of truth, tracked in `~/.cruor`. Check `docker stack ls` and `ls ~/services/` for what's running. Do **not** create stacks outside `~/services/`.
- **Version control:** cruor-specific files in `~/.cruor` bare repo; shared dotfiles from `~/.cfg` (mini-dots). Stage with `git --git-dir="$HOME/.cruor" --work-tree="$HOME" add -f <file>`. Do **not** `git init` inside a service dir.
- **GPU:** NVIDIA GeForce GTX 980 (Maxwell/sm_52). CUDA 13 dropped Maxwell — GPU uses **Vulkan** for ollama. Driver version: `pacman -Q nvidia`.
- **Ollama:** Native systemd service (not Docker). Models at `/var/lib/ollama/`. Override: `/etc/systemd/system/ollama.service.d/override.conf`.
- **Forgejo runner:** Plain compose at `~/services/forgejo/runner.yml` (`docker compose -f runner.yml up -d`), NOT a Swarm service. Reason: must be on `runner-net` bridge so its cache server is reachable from CI job containers.
- **Backups:** `sanoid.timer` (ZFS snapshots) + `borgmatic.timer` (dumps + Hetzner storage box). Check schedules with `systemctl list-timers`. Borgmatic config: `/etc/borgmatic/config.yaml`; reference copy in `~/.config/borgmatic/`.
- **Disk discipline:** Put container volumes, build caches, DB dumps, downloads on `/mnt/1tbhdd`, not `/`. `/mnt/1tbhdd` is ZFS — `zfs destroy` needs explicit go-ahead.
- **Careful with:**
  - **Immich DB + photo library** — irreplaceable. Do not touch its volumes.
  - AdGuard outage = no LAN DNS (it runs here at `192.168.10.126`).
  - Rolling release: never `pacman -Syu` unprompted.
