# glacies

Main workstation (Arch Linux, daily driver). Remote-manages cruor, fumus, pi.

## Dotfiles

```bash
git clone --bare git@github.com:rudsvar/glacies.git "$HOME/.cfg"
alias conf="git --git-dir=$HOME/.cfg --work-tree=$HOME"
```

## Hardware / OS

- AMD Ryzen 7 7800X3D (8C/16T), 30 GiB RAM + 4 GiB zram swap
- AMD Radeon RX 7900 XTX (Navi 31 / RDNA3), AMD Raphael integrated GPU
- 466 GB SSD root (`/dev/sda2`), btrfs, ~73% used
- Btrfs subvolumes: `@` `/`, `@home` `/home`, `@log` `/var/log`, `@pkg` `/var/cache/pacman/pkg`, `@.snapshots` `/.snapshots`
- Additional NVMe drives (ntfs, Windows/gaming) — not automounted; mountpoints at `/mnt/windows`, `/mnt/1tbssd`, `/mnt/1tbm2`, `/mnt/2tbm2`
- Arch Linux rolling, fish shell

## Storage

| Mount           | What                                          |
|-----------------|-----------------------------------------------|
| `/`             | 466 GB btrfs SSD, daily system + home         |
| `/mnt/hetzner`  | 1 TB Hetzner Storage Box, SSHFS automount     |
| `/mnt/windows`  | ntfs NVMe (Windows/games), manual mount       |
| `/mnt/1tbssd`   | ntfs NVMe, manual mount                       |
| `/mnt/1tbm2`    | ntfs NVMe, manual mount                       |
| `/mnt/2tbm2`    | ntfs NVMe, manual mount                       |

Hetzner Storage Box: subaccount `u587634-sub2`, mounted via SSHFS at `/mnt/hetzner`. See `fstab` for options.

Btrfs snapshots managed by snapper (`.snapshots` subvolume). Don't delete snapshots without checking snapper config.

## Docker

Compose in `~/git/glacies/`. Currently one service:

| Service       | Purpose                                      |
|---------------|----------------------------------------------|
| beszel-agent  | Host metrics agent, reports to cruor beszel hub |

## Ollama

Native `ollama.service` (systemd). Uses AMD GPU via ROCm. Keep-alive override: 15 min.

Drop-in at `/etc/systemd/system/ollama.service.d/override.conf`.

## Homelab network

All heavy services run on **cruor** (Docker Swarm, `~/services/`). See `~/.claude/hosts/cruor.md` for full detail.

- DNS: AdGuard on cruor (`192.168.10.126`)
- Reverse proxy: Traefik on cruor
- VPN: wg-easy on cruor, endpoint `nex.rudsvar.xyz`, subnet `10.9.0.0/24`
- Monitoring: Beszel hub on cruor, agents on all hosts
