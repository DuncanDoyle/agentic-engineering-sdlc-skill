# Phase status

## Phase
Phase: <N> — <name>
Base: <HEAD before any phase work>
Docs: docs/phases/phase-<N>/
Status: <one line, e.g. "implementing; 2.1 open for a user-found bug">

### Queue
<Plan steps and tracked items, in order. See the skill's Tracking section for the line format.>
- [ ] Q1 <item> ← CURRENT

### Exit gates
- [ ] tests/vet pass (observed)
- [ ] all queue items done or deferred
- [ ] design+plan cross-model review + triage: <path>
- [ ] phase cross-model review + triage: <path>
- [ ] decisions.md / design / plan in sync with code
- [ ] phase-<N>-complete.md written, roadmap updated, tracked items closed

## Sub-phase
<"none" when no sub-phase is active.>
Sub-phase: <N>.<M> — <name>
Kind: planned | stabilization
Base: <SHA>
Brief: docs/phases/phase-<N>/phase-<N>.<M>-brief.md

### Allowed work
<planned: features within the approved design | stabilization: bug fixes, missing designed behaviour, tests, docs>

### Not allowed
<planned: design changes without decisions.md + user approval | stabilization: new features, architecture changes, new dependencies>

### Queue
- [ ] <item> ← CURRENT

## Carry-over (deferred to later phases)
- <item> — <reason>

## Notes
<Anything the next session needs that isn't in the brief or plan. Blocked close attempts: "YYYY-MM-DD Close blocked: <gates>".>
