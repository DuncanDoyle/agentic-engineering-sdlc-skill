# Sub-phase <N>.<M> — <title>

Kind: planned | stabilization
Base: <HEAD before this sub-phase's setup commit>
Issues: <#n, #m> | Plan steps: <refs>

## Problem / goal
<What is wrong or missing, as the user observes it. Include a reproduction.>

## Expected behaviour
<Observable input → output. A table when there is more than one case.>

| Input / action | Expected |
|---|---|

## Root cause (if known)
<Where and why. Do not prescribe the fix.>

## Acceptance tests
<At the highest practical boundary (CLI, API, UI model) where the behaviour is observable. Each must fail before the change.>

## Scope
In: <files/packages>
Out: <files/packages, and tempting adjacent fixes to leave alone>

## Plan / design impact
<none | what changes in design.md / implementation-plan.md / decisions.md>

## Definition of done
- [ ] acceptance tests fail before, pass after (report both)
- [ ] full test suite passes
- [ ] cross-model review of `git diff <base>..HEAD` + triage (stabilization)
- [ ] phase-<N>.<M>-complete.md written; phase-status.md updated; issues closed with root cause + commit
