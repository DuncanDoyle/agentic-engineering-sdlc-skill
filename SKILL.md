---
name: agentic-engineering-sdlc
description: Use when a software project is built with AI agents across many sessions and follows a roadmap of phases — creating the roadmap, starting a phase, writing a phase design or implementation plan, reviewing a phase, starting or continuing a sub-phase (fix round, patch cycle, stabilization), or closing a phase. Also when a repo has docs/phase-status.md or docs/roadmap.md.
---

# Agentic Engineering SDLC

## Overview

A controlled lifecycle for delivering software with agents: roadmap → phases → independent review → sub-phases → close. **The repo is the single source of truth**: where the project stands lives in `docs/phase-status.md`, every step leaves a file behind, and nothing closes without a review by a *different* model than the one that wrote the code.

This skill owns *structure and gates*. Per-step technique comes from superpowers (brainstorming, writing-plans, subagent-driven-development / executing-plans, test-driven-development, receiving-code-review, finishing-a-development-branch). Where those skills name a save path, use the path below instead.

## Layout

```
docs/
  roadmap.md                  # all phases: goal, scope, status
  phase-status.md             # ONLY "where are we now" — active phase/sub-phase, base SHA, queue, gates
  decisions.md                # append-only decision log
  phases/phase-<N>/
    design.md
    implementation-plan.md
    phase-<N>.<M>-brief.md    # one per sub-phase
    phase-<N>.<M>-complete.md # one per sub-phase, written at close
    phase-<N>-complete.md     # written at phase close
    reviews/<scope>-<reviewer>.md   # e.g. design-codex.md, phase-codex.md, 4.2-claude.md
```

Templates for every file are in `templates/`. Copy the template; every heading in it is a required slot — write `n/a` rather than delete one. When you edit an existing file that predates a template, add its missing slots.

**Base SHAs make review diffs exact.** `Base:` = HEAD before any work on that phase or sub-phase, recorded in the same commit as the setup docs. The review diff `git diff <base>..HEAD` then holds the design or brief plus the work — which the reviewer needs anyway.

Never mirror project state into agent memory files — memory goes stale; `phase-status.md` doesn't.

## Entry points

**Before any entry point:** read `docs/phase-status.md`, then tell the user which phase/sub-phase you'll act on and wait for confirmation. A request that already names the phase/sub-phase counts as confirmation.

| User says | Do |
|---|---|
| "set up the roadmap" / new project | Brainstorm with the user → `roadmap.md`, `phase-status.md` (Phase 1, not started), `decisions.md`. |
| "start phase N" | 1. Record `Base: <git rev-parse HEAD>` in `phase-status.md`. 2. Design (brainstorming) → `design.md`. 3. Plan (writing-plans) → `implementation-plan.md`. If the plan is too big for one reviewable change, split it into **planned** sub-phases N.1, N.2… in the plan. 4. **Cross-model review of design + plan** → triage → user approves before any code. |
| implement | superpowers execution skills; update the queue in `phase-status.md` as items finish. |
| "review phase N" | Cross-model review of `git diff <base>..HEAD` against design + plan → `reviews/phase-<reviewer>.md` → triage. Accepted findings become tracked items (see Tracking) and are **proposed** as stabilization sub-phases; starting one is its own entry point. Typo-level doc fixes: just do them. |
| "start sub-phase N.M" | Fill the Sub-phase block of `phase-status.md` (the Phase block stays — the phase is still open); write `phase-<N>.<M>-brief.md` from the template; commit both. Works whether the work came from a review, user testing, or the plan. The brief may be executed by a separate session. |
| "continue sub-phase" | Read `phase-status.md` + the brief; work the queue in order, marking `← CURRENT`. |
| "close sub-phase" / "close phase" | Run the exit gates below. If any fails, append a dated `Close blocked: <failing gates>` line to Notes in `phase-status.md` and give the user options. Otherwise write the `-complete.md` record (sub-phase: from status; phase: summary table of all sub-phases + deferred items), update `roadmap.md`, clear the Sub-phase block (sub-phase) or reset `phase-status.md` to the next phase (phase). Ask before starting the next phase. |

## Tracking

Rank every tracked item P1–P4 on the review scale, whatever its source (review, user testing, plan). If the repo uses GitHub issues: one issue per accepted finding (priority in the body), closed with a comment naming root cause + commit. Otherwise the queue in `phase-status.md` is the tracker, one line per item:

```
- [ ] Q3 (P1) Lines() ignores unterminated last line — src: reviews/phase-codex.md#1
- [x] Q3 (P1) Lines() ignores unterminated last line — a1b2c3d: counted only "\n"; now +1 for trailing content
```

## Sub-phase kinds

| Kind | From | Allowed | Not allowed |
|---|---|---|---|
| `planned` | split in the implementation plan | features within the approved design | design changes without a `decisions.md` entry and user approval |
| `stabilization` | review findings, bugs | bug fixes, missing designed behaviour, tests, docs | new features, architecture changes, new dependencies |

## Briefs describe outcomes, not code

A brief states the observable behaviour (input → expected output table), the boundary where it's tested, files in/out of scope, and the definition of done. It may cite the root cause; it never prescribes the implementation or asserts internal state as the acceptance test. Expected outputs the design doesn't state are marked `(inferred)` and confirmed with the user — or recorded in `decisions.md` — before implementation. A brief that dictates the fix lets a wrong fix pass its own test — and you get N.M+1, N.M+2 for the same behaviour.

## Cross-model review

The reviewer must be a different model family from the author: Claude wrote it → Codex reviews; Codex wrote it → Claude reviews. Reviewers are read-only and write nothing but their report.

```bash
# Claude authored → Codex reviews (read-only sandbox, report saved to file)
# Run the tests yourself first: the read-only sandbox can't build. Pass the output in.
codex exec --sandbox read-only -o docs/phases/phase-N/reviews/<scope>-codex.md "$(cat <<'EOF'
You are reviewing work you did not write. Read docs/phases/phase-N/design.md and
implementation-plan.md (and the brief, for a sub-phase), then `git diff <base>..HEAD`.
Report findings ranked P1 correctness bug, P2 design/plan mismatch or incomplete step,
P3 test gap (incl. tests asserting mechanism instead of observable behaviour),
P4 fragile for later phases (see docs/roadmap.md). Each: file:line, evidence, why.
Test results from the author (you cannot run them): <paste go test / lint output>.
Do not edit files.
EOF
)" < /dev/null   # without this, codex exec waits on stdin

# Codex authored → Claude reviews
claude -p --disallowedTools "Edit,Write,NotebookEdit" "<same prompt>" > docs/phases/phase-N/reviews/<scope>-claude.md
```

| Scope | When | Required? |
|---|---|---|
| design + plan | before implementation | yes |
| phase diff | before closing the phase | yes |
| sub-phase diff | before closing a sub-phase | yes for stabilization; planned: at the phase review |

**Triage** (author, using superpowers:receiving-code-review): leave the reviewer's text verbatim; add only the header lines from `templates/review.md` at the top and a `## Triage` table at the bottom. Every finding gets `accept` / `reject: <reason>` / `defer: <item>`; findings the author spotted go in the same table marked `author`. Disagreements go to the user. **Fallback:** if the other CLI is unavailable or fails, review in a fresh subagent and write `Cross-model: NO — <reason>` at the top of the review file.

## Exit gates (close only when all hold)

- [ ] Tests and vet/lint pass; observed, not assumed.
- [ ] Every plan step / brief item done or explicitly deferred to an issue.
- [ ] Required cross-model review exists, with triage; no untriaged P1/P2.
- [ ] Accepted P1s fixed; other accepted findings fixed or tracked.
- [ ] `decisions.md` has any design deviations; design/plan docs match the code.
- [ ] `-complete.md` written; `roadmap.md` and `phase-status.md` updated; issues closed with a comment naming root cause + commit.

A required step skipped earlier (e.g. no design review) stays an open gate of the enclosing phase; running it late satisfies the gate — mark the review file `retroactive`. A cross-model review is one read-only command taking minutes, not a "big review": offer it before treating the user as having declined it (no way to ask → run it).

Only the user can waive a gate, explicitly. Record it in the `-complete.md` under Waivers with the user's words. Never mark complete to unblock a deadline.

## Common mistakes

| Mistake | Fix |
|---|---|
| Review findings only in chat | Review file + triage section, always |
| Same model reviews its own work | Cross-model, or record `Cross-model: NO` |
| Brief prescribes code; test asserts internals | Behaviour table + boundary test |
| `-complete.md` written for some sub-phases only | Every sub-phase close writes one |
| Docs scattered (`docs/plans/`, `docs/`, `docs/superpowers/`) | Layout above, nothing else |
| No base SHA → review diff guessed | Record `Base:` at every phase/sub-phase start |
| Project state copied into agent memory | Repo only |
