# Global user instructions (rudi)

Applies to every Claude Code session. Keep concise; project-level `CLAUDE.md` files override/extend this.

## Operating principles

- **Stability over novelty.** These are real systems I use daily. Prefer the smallest, most reversible change. Don't upgrade, refactor, or "modernize" things that work unless asked.
- **Investigate before changing.** If something looks unfamiliar (a file, a container, a branch, a mount), assume it's mine and in-progress. Ask before touching.
- **State blast radius before acting.** For any command that touches shared infra (a remote host, a running container, a database), say what it will affect and wait for approval unless I've already green-lit the specific action.
- **Ask before installing packages.** Don't `pacman -S`, `apt install`, `pip install --user`, etc. without checking.

## Keeping docs current

When something in these files is **wrong, outdated, or surprising**, update it as part of the same task. Stale notes are worse than missing ones.

Prefer **pointers to live sources of truth** over hardcoded values that decay — say "see `docker stack ls`" not "the running stacks are X, Y, Z". Hardcode only things that can't be derived: rationale, non-obvious config, host-specific quirks, the *why* behind a workaround.

## Data safety (hard rules)

Never run these without an explicit, in-scope go-ahead from me for *this specific target*:

- `rm -rf`, `rm -r` on anything outside `/tmp` or a scratch dir
- `docker volume rm`, `docker system prune -a --volumes`, `docker compose down -v`
- `truncate`, `> file` redirection that clobbers non-scratch files
- Database `DROP`, `TRUNCATE`, destructive migrations, `--force` restores
- `git reset --hard`, `git clean -fdx`, `git push --force`, branch/worktree deletion
- `btrfs subvolume delete` (incl. snapper snapshots), `zfs destroy`, `mkfs`, `dd` to a block device, partition edits
- Anything that reformats, unmounts, or reorganizes `/mnt/1tbhdd` or `/media/rudi/*`
- Mass-rename / mass-move across media libraries (Immich, Jellyfin, romm, qbittorrent downloads)

When unsure whether data is disposable: **stop and ask**. "Looked unused" is not proof.

## Before deleting anything

1. Confirm what created it and whether anything still references it (`grep`, `docker ps -a`, `systemctl`, compose/stack files).
2. Check size & mtime — recent or large files deserve extra scrutiny.
3. Prefer moving to `/tmp/trash-YYYYMMDD/` over deleting, when feasible.
4. For containers/volumes: check `docker volume ls`, bind mounts, and stack files first.

## Homelab overview

All hosts behind Cloudflare tunnels (`cloudflared`) + Traefik where applicable; fail2ban on each. DNS `*.rudsvar.xyz` wildcarded through Cloudflare. LAN ad-blocking DNS: **AdGuard on cruor (192.168.10.126)**.

| Host    | Role                              | OS             | SSH                          | SSHFS mount (from glacies) |
|---------|-----------------------------------|----------------|------------------------------|----------------------------|
| glacies | Main workstation                  | Arch Linux     | local                        | —                          |
| cruor   | LAN Docker Swarm manager          | Arch Linux     | `rudi@cruor.rudsvar.xyz`     | `/mnt/cruor`               |
| guthix  | LAN k3s single-node cluster       | Arch Linux     | `rudi@guthix.rudsvar.xyz`    | —                          |
| fumus   | Public VPS (Hetzner, DE)          | Ubuntu 24.04   | `rudi@fumus.rudsvar.xyz`     | `/mnt/fumus`               |
| pi      | RPi, WireGuard + monitoring       | Raspbian 11    | `rudi@pi.rudsvar.xyz`        | `/mnt/pi`                  |
| umbra   | Phone (not SSH-managed)           | —              | —                            | —                          |

**Per-host details live in `~/.claude/hosts/<name>.md`. Read the relevant one on demand before working with that host** — don't load all five eagerly.

## Dotfiles — bare repo pattern

All hosts track dotfiles and service configs in bare git repos at `~/.cfg` (mini-dots, shared) and a machine-specific repo (e.g. `~/.cruor`, `~/.glacies`). Root `.gitignore` is `*` — nothing tracked by default; always stage explicitly with `-f`. The `conf` / `cruor` / `glacies` aliases are fish-only — use the full command in scripts/tools:

```sh
git --git-dir="$HOME/.cfg" --work-tree="$HOME" add -f <file>
git --git-dir="$HOME/.cfg" --work-tree="$HOME" commit -m "message"
```

## How to work with me

- **Reading state is free:** `ls`, `df`, `docker ps`, `systemctl status`, `journalctl`, `git status/log/diff`, `ss`, `ps`. No need to ask.
- **Don't mass-restart services** to "refresh" them. Each restart is user-visible.
- **Swarm deployments** (`docker stack deploy`) should be preceded by a config diff summary.
- **Prefer idempotent, reversible fixes.** Config-file edits beat one-off imperative commands; note where the change lives.
- **Secrets:** never echo, commit, or send to external services. If you spot one, tell me.
- **Shell:** I use fish most places; stick to POSIX sh in scripts unless I've said otherwise.

## Environment notes

- Auto-memory lives at `~/.claude/projects/-home-rudi/memory/` — check `MEMORY.md` there for evolving context.
- Project-level `CLAUDE.md` files (e.g. `~/CLAUDE.md`) may add specifics; they win over this file where they overlap.
