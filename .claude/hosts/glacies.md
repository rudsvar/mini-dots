# glacies — main workstation

- **Hardware:** MSI MS-7D75, AMD Ryzen 7 7800X3D (8C/16T), 32 GiB DDR5. AMD Radeon RX 7900 XTX.
- **OS:** Arch Linux, btrfs root (~466 GB) with snapper snapshots (`/.snapshots`).
- **Role:** primary desktop + dev machine. All other hosts are managed from here over SSH or via SSHFS mounts at `/mnt/<host>/`.
- **Local services:** `~/services/` — check `docker compose ls` for what's running. Heavy workloads run on cruor/guthix.
- **Dotfiles:** `~/.cfg` (mini-dots, shared) + `~/.glacies` (glacies-specific). Fish aliases: `conf` and `glacies`.
- **Careful with:**
  - Btrfs snapshots — don't delete without checking snapper config.
  - `~/git/` holds infra repos; treat as precious.
