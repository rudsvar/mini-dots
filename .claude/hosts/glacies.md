# glacies — main workstation

- **Hardware:** MSI MS-7D75, AMD Ryzen 7 7800X3D (8C/16T), 32 GiB DDR5 @ 6000 MT/s + 4 GiB swap.
- **OS:** Arch Linux, btrfs root (466 GB), with snapshots (`/.snapshots` subvolume).
- **Role:** primary desktop + dev machine. Where I write code, edit configs, and deploy to the other hosts from.
- **Compose / stacks live at:** `~/git/glacies/` (this host's own services).
- **Docker:** currently just `beszel-agent` locally — heavy stuff runs on cruor/fumus.
- **Careful with:**
  - Btrfs snapshots on `/.snapshots` — don't delete without checking snapper config.
  - `~/git/` is the source of truth for a lot of infra; treat as precious.

I usually work from here; other hosts are reached over SSH.
