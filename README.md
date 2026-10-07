# agentic-engineering-sdlc skill

Agent skill for delivering a software project with AI agents (Claude Code, Codex, …) in a controlled, phased way rather than by vibe coding: a roadmap of phases, a design and implementation plan per phase, cross-model review (Codex reviews Claude's work and vice versa), sub-phases for planned increments and stabilization, explicit exit gates, and a file-based audit trail in the project's `docs/`.

It builds on [superpowers](https://github.com/obra/superpowers) for per-step technique (brainstorming, writing-plans, subagent-driven-development, receiving-code-review, …) and adds the lifecycle structure on top.

## Layout

The repository root is the skill.

| Path | Purpose |
|---|---|
| `SKILL.md` | Lifecycle, entry points, exit gates, cross-model review |
| `templates/` | Project doc templates: roadmap, phase status, sub-phase brief, review, completion record, decision log |
| `scripts/install-skill.sh` | Installs the runtime skill into the shared skills directory |
| `docs/testing.md` | Test scenarios used to develop the skill, and what they found |

## Usage

Invoke the skill and say what you want. In Claude Code that's `/agentic-engineering-sdlc <request>`; in Codex, `$agentic-engineering-sdlc <request>` or ask it to use the skill. In a repo with `docs/phase-status.md` or `docs/roadmap.md`, a plain request ("close phase 4") usually loads the skill on its own.

| Request | What happens |
|---|---|
| `/agentic-engineering-sdlc what can I do?` | Lists the entry points, where the project stands, and the sensible next step |
| `/agentic-engineering-sdlc set up the roadmap for <project>` | Brainstorm → `roadmap.md`, `phase-status.md`, `decisions.md` |
| `/agentic-engineering-sdlc start phase 4` | Record base SHA → design → implementation plan → cross-model review of both → your approval before code |
| `/agentic-engineering-sdlc review phase 4` | Cross-model review of the phase diff → triage → findings tracked and proposed as stabilization sub-phases |
| `/agentic-engineering-sdlc start sub-phase 4.1 for #31 and #32` | Writes `docs/phases/phase-4/phase-4.1-brief.md` (behaviour, not code) and fills the Sub-phase block |
| `/agentic-engineering-sdlc continue sub-phase 4.1` | Reads the brief + status and works the queue — in the same or a fresh session, Claude or Codex |
| `/agentic-engineering-sdlc close sub-phase 4.1` / `close phase 4` | Checks exit gates, writes the `-complete.md` record, advances the status |

A typical stabilization round:

```
/agentic-engineering-sdlc review phase 4                  # Codex reviews, author triages, fix work queued
/agentic-engineering-sdlc start sub-phase 4.1 for Q3, Q4  # brief + status written
# new session
/agentic-engineering-sdlc continue sub-phase 4.1          # implement against the brief
/agentic-engineering-sdlc close sub-phase 4.1             # cross-model review, gates, 4.1-complete record
```

## What it creates in a project

```
docs/
  roadmap.md
  phase-status.md
  decisions.md
  phases/phase-<N>/
    design.md
    implementation-plan.md
    phase-<N>.<M>-brief.md
    phase-<N>.<M>-complete.md
    phase-<N>-complete.md
    reviews/<scope>-<reviewer>.md
```

## Install

```bash
scripts/install-skill.sh                      # -> ~/.agents/skills/agentic-engineering-sdlc
AGENTS_SKILLS_DIR=/somewhere scripts/install-skill.sh
```

Then symlink it where an agent expects skills, if needed:

```bash
ln -s ~/.agents/skills/agentic-engineering-sdlc ~/.claude/skills/agentic-engineering-sdlc
```

The installer uses `rsync --delete`, so rerunning it after a `git pull` keeps the installed skill in sync with the repository.

Cross-model review needs both the `codex` and `claude` CLIs on the `PATH`. Without the other CLI the skill falls back to a fresh-subagent review and records that the review was not cross-model.

## Validate

With Codex installed, run:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```
