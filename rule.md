# Model delegation rule (model-thrift plugin)

The session model is the expensive one. Spend it on judgment; hand bulky, low-judgment work to cheaper helper subagents. Quality comes first: a helper finds and executes, the session model decides.

## The grid

Complexity decides who thinks. Volume decides whether a helper is worth its overhead.

|  | Small volume | Large volume |
|---|---|---|
| Hard or medium (needs judgment) | session model does it | session model plans, helper executes the plan |
| Easy (no judgment) | session model does it, immediately | helper |

Volume = what the session model itself would have to read or write. If that is less than writing a brief plus reading the report, do it yourself: one grep, one known file, a few-line edit, anything you need verbatim for an Edit.

## Which helper model

- Search, exploration, reading many files, logs, PDFs: `sonnet`, whatever the session model is.
- Executing a concrete plan, mechanical code changes, first-pass code review: one tier below the session model, never below `sonnet` (fable session -> `opus`, opus session -> `sonnet`). In a sonnet session do the work yourself.
- Keeping work on the session model inside a subagent: pass the session model's own alias.
- Project instructions may set a floor for their own code (e.g. "C++ execution never below `opus`") or mark code as sensitive. Those are refinements of this rule, not conflicts: apply them without asking.

## Before delegating

0. Filtering a big output of a known format (test run, log, build): a sandbox tool such as `ctx_execute`, if installed, beats any helper. Filters never drop errors, warnings, counters or crashes.
1. Unfamiliar area: first a `sonnet` scout brings facts, then judge complexity. Misjudged complexity comes from unseen code, not from too little thinking.
2. Hard and large: write the plan, then re-check it backwards from the goal (fewest steps, each step valid) before handing it off.
3. Every brief tells the helper to stop and report instead of improvising when the plan does not match the code, a design choice appears, the scope grows beyond the plan, or it reaches code the project marks as sensitive.
4. Every brief carries the decisions made, the approaches already rejected, and the memory files whose traps apply to this work. The helper starts with nothing else.
5. Reading for diagnosis or documents (logs, test output, PDFs): the helper returns verbatim quotes with line or page numbers, counts (total errors and warnings vs quoted), and one line on what it skipped as noise. A paraphrase without quotes is not accepted.
6. Iteration loops: the helper changes only the parameters the plan names and reports every intermediate value.

## After delegating

- Verify the helper's result before calling the work done. Check the specific lines it points to; do not re-read everything it already summarized. Check `git status` for files touched outside the plan.
- Code review: helpers find issues; the session model verifies each finding against the code and personally reviews the hunks the project marks as sensitive.
- Fixes: small or subtle ones the session model writes itself; large mechanical ones go to a helper with an exact plan.

## Visual work

Every image stays in context and is re-read on every later turn, so a screenshot costs far more than the moment it is taken.

- Measurable criterion (stair-stepping, brightness, whether an object is in frame, the diff between two frames): measure it with a script over the pixels and read the number, not the image.
- Crop to the region in question. Downscale only when pixel-level detail does not matter. One screenshot per question.
- Before trusting numbers from a capture series, look once, cropped, at its first frame to confirm it shows the right thing.
- Iteration loops (tweak, capture, check, repeat) with a criterion you can state go to a helper; the session model sees only the final before/after.
- The verdict "does it look right" stays with the session model.

## Iterative work in editors (Blender, Unreal, materials)

Most savings here come from working smarter on the session model, not from delegating.

- Before the first attempt, check memory for a recipe from a past success; after a success, save the recipe.
- Verify each operation with printed numbers (dimensions, vertex/triangle counts, non-manifold edges, UV islands, material slots), not a viewport screenshot.
- Checkpoint (duplicate the object or save the file) before any destructive operation; on failure revert instead of repairing.
- One operation per call; print a short summary, never a full dump.
- Judge shape, proportions and look on the session model, with one final cropped screenshot from fixed angles.
- Delegate an iteration loop only when its acceptance criterion is a number (triangle budget, no UV overlaps, batch rename or export). Never delegate judging form or look.

## Session size

Every turn re-sends the whole context, so a long session costs more per turn than the work itself; auto-compaction only caps it near the window limit.

- When a task is finished and the next one is unrelated, suggest a new session in one line, after saving anything worth keeping to memory.
- When this plugin's hook reports a large context, relay it in one line only after the whole task the user asked for is finished. Never suggest a new session mid-task, and do not treat a finished sub-step as the end of the task.

## Always

- Pass `model` explicitly on every Agent call, including agents that skills launch. A call without it is rejected by this plugin's hook, because an omitted model silently inherits the expensive one.
- Before each helper launch, write one line in English, whatever language the conversation is in: `🔀 <model>: <task>` (e.g. `🔀 sonnet: find where the store map widget lives`).
- If another instruction (CLAUDE.md, memory, a skill) contradicts this rule outright (not a stricter floor, see above), tell the user once and ask which wins. Do not pick silently.
