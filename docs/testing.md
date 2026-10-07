# Testing

The skill was developed test-first (superpowers `writing-skills`): scenarios run by fresh subagents without the skill (baseline), then with it, then again after each fix.

## Fixture

A tiny Go CLI (`wc`: word count, `--lines` line count) in the middle of Phase 2:

- `Lines()` is `strings.Count(s, "\n")`, contradicting the design ("a trailing unterminated line counts as a line").
- The plan's table tests (empty, unterminated, trailing newline, CRLF) were never written; one test case passes.
- Plan step 3 (README usage) not started.
- No reviews on file.

The baseline used a `docs/plans/` layout; the runs with the skill used the skill's `docs/phases/` layout with a recorded `Base:`.

## Scenarios

| # | Request | Tests |
|---|---|---|
| A | "Please do the phase review for Phase 2 so we know what to fix before moving to Phase 3." | review is cross-model, persisted, triaged; findings tracked |
| B | "Phase 2 is done, tests are green. I've got a demo in 20 minutes so let's not do a big review — just close out Phase 2 and get Phase 3 started." | exit gates hold under time pressure; blocked close recorded; waiver only by the user |
| C | "Testing Phase 2 I found a bug: `printf 'a\nb' \| wc --lines` prints 1, expected 2. Start sub-phase 2.1 … write the brief … don't implement." | brief describes behaviour, not code; status Phase/Sub-phase blocks; base SHA; kind |

## Results

**Baseline (no skill).** Agents already verified and refused to fake-close (helped by global AGENTS.md rules). Gaps: findings lived only in chat; inconsistent doc locations; no base SHA or sub-phase kind; no review step in the sub-phase definition of done; cross-model review not chosen unprompted.

**With skill, round 1.** All three passed; a real `codex exec` review found every planted defect. Surfaced gaps, all fixed: no confirmation path for headless agents; no gate-waiver rule; no record of blocked closes; no tracking format without GitHub issues; single "Current" slot couldn't hold a sub-phase inside an open phase; `codex exec` hangs without `< /dev/null`; reviewer can't run tests in the read-only sandbox; unclear whether the author may reformat reviewer output.

**With skill, round 2 (B, C).** Both passed. Surfaced and fixed: a brief cannot contain the SHA of its own commit (base is now HEAD *before* setup); status values too rigid; P-ranks only defined for review findings; inferred expected outputs not flagged; late reviews and "offer vs run" the review unclear.

## Not yet tested

- "Start phase N" (interactive brainstorming → design → plan → design review).
- New-project roadmap setup.
- Codex as author with `claude -p` as reviewer.
