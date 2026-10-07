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
