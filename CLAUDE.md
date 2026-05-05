# glacies — CLAUDE.md

Supplements `~/.claude/CLAUDE.md` (global rules). Per-host details are in `~/.claude/hosts/<name>.md` — read the relevant one before working on a remote host, don't load all eagerly.

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
| fumus | `fumus.rudsvar.xyz`  | `~/director/`     | Docker Swarm         |

Deploy cruor/fumus: `docker stack deploy -c <name>.yml <name>` from the service dir.
Deploy pi: `docker-compose -f <name>.yml up -d` from the service dir.

## Where to find things

- Host details, disk layout, running services, caveats: `~/.claude/hosts/<name>.md`
- Homelab migration plan: `~/plan.md`
- Auto-memory: `~/.claude/projects/-home-rudi/memory/MEMORY.md`
