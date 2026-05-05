# glacies — CLAUDE.md

Supplements `~/.claude/CLAUDE.md` (global rules). Per-host details are in `~/.claude/hosts/<name>.md` — read the relevant one before working on a remote host, don't load all eagerly.

## What goes where

- **README.md** — human-facing (shown on GitHub): hardware, storage layout, setup/clone instructions. Stable facts only; omit service lists or anything that changes often.
- **CLAUDE.md** — Claude-facing: pointers to where things live, deploy commands, operational rules. Prefer "check X" over copying data that will rot. Keep concise to save context.
- **`~/.claude/hosts/<name>.md`** — per-host operational detail: role, disk layout, running services, what to be careful with. Update when services change.

## This machine

- Services: `~/services/` — plain Docker Compose
- Dotfiles: `~/.cfg` bare repo → `github.com/rudsvar/glacies`, alias `conf`
  - Everything in `$HOME` is gitignored by default — add files explicitly with `conf add -f <file>`
  - This prevents accidental inclusion of secrets; never use `conf add -A` or `conf add .`
- Shell: fish

## Homelab at a glance

| Host  | SSH                  | Services          | Orchestration        |
|-------|----------------------|-------------------|----------------------|
| cruor | `cruor`              | `~/services/`     | Docker Swarm         |
| pi    | `pi.rudsvar.xyz`     | `~/services/`     | docker-compose v1.25 |
| fumus | `fumus.rudsvar.xyz`  | `~/services/`     | plain Compose        |

Deploy cruor: `docker stack deploy -c <name>.yml <name>` from the service dir.
Deploy fumus: `cd ~/services/<service> && docker compose -f <service>.yml up -d`.
Deploy pi: `docker-compose -f <name>.yml up -d` from the service dir.

## Where to find things

- Host details, disk layout, running services, caveats: `~/.claude/hosts/<name>.md`
- Auto-memory: `~/.claude/projects/-home-rudi/memory/MEMORY.md`
