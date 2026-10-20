---
name: sharia-compliance-report
description: "Use when assembling a structured sharia compliance report from screening evidence, or when a verdict must be written up for a client, committee, or file — enforces the standard report envelope with verdict, ratio table, evidence, dissent, purification, and escalation."
version: 1.0.0
author: Sharia Skills
---

# Skill: Sharia Compliance Report

## Purpose
Produce the durable artefact: a compliance report that a reviewer can audit without re-running the analysis. It assembles evidence from the screening skills into one consistent envelope and refuses to paper over gaps.

**This skill produces a report.** Inputs are the outputs of the screening and review skills; it does not re-derive them.

## When to Use
* User command: `/sharia-compliance-report`
* Autonomous trigger: a screening result must be written for a client, investment committee, or compliance file; several holdings must be reported together; a prior report needs a correction or re-issue.
* Not for: the screening itself (use `sharia-stock-screening`) or batch execution (use `sharia-screening-pipeline`).

## Prerequisites & Context Gathering
1. Read `references/output-contract.md` — the schema is mandatory.
2. Read `references/precedence.md` to confirm the governing standard.
3. Read `references/thresholds.yaml` for the thresholds cited.
4. Collect per-subject evidence: ratio inputs and sources, activity findings, purification ratios, and any dissent.

If evidence is incomplete, the report says so in `limits`. It does not fill gaps with plausible numbers.

## Execution Workflow

### Step 1: Fix the scope
State what is covered and what is not: subjects, period, standard, data date, and the decision the report supports.

### Step 2: Populate the envelope
For each subject:
```
subject:      ticker / fund / product / contract
standard:     named standard + edition + date verified
as_of:        date of underlying data
verdict:      compliant | non_compliant | questionable | insufficient_data
ratios:       test, numerator, denominator, value, threshold, result, source
activity:     business-activity screen result, disputed exposures
evidence:     source per input, period covered
purification: ratio and amount, or not applicable
dissent:      positions where scholars or standards disagree
escalate:     true/false + the specific question for a scholar
limits:       what the assessment does not cover
```

### Step 3: Write the summary first
Open with:
* Scope and governing standard.
* Count of verdicts by category.
* Material findings (fails, near-threshold names, unresolved data).
* Decisions required from the reader.

### Step 4: Preserve the audit trail
* Every number carries a source and a period.
* Separate fact, inference, and judgement.
* Mark estimates `est.` with the method.
* Record the standard's confidence level where it is medium.

### Step 5: Handle disagreement explicitly
If two standards or two scholars would decide differently, the report shows both in `dissent` and states which governs and why. Suppressing disagreement is a defect.

### Step 6: Attach the disclaimer
Verbatim from `references/output-contract.md`. It is not optional and not paraphrased.

## Output
```markdown
# Sharia Compliance Report
Scope · Standard · Data date · Prepared for

## Summary
- 24 subjects: 19 compliant, 2 questionable, 2 non-compliant, 1 insufficient data
- Material: BBCA fails business activity; ANTM passes but sits at 31% debt (threshold 33.33% under MSCI)

## Findings
### TLKM — compliant
| Test | Value | Threshold | Result | Source |
...

### BBCA — non_compliant
...

## Dissent and escalation
...

## Limits
...

> This is an informational screening based on the named standard and publicly
> available data. It is not a fatwa, not legal or tax advice, and not a
> substitute for a qualified sharia scholar or your institution's sharia
> supervisory board. Standards differ; a verdict is only meaningful relative to
> the standard cited.
```

## Constraints & Guardrails
* DO NOT invent evidence to complete the envelope.
* DO NOT mix standards across subjects without labelling each.
* DO NOT present an estimate as reported data.
* DO NOT omit `dissent` when disagreement exists.
* DO NOT soften `non_compliant` into "may have concerns".
* DO NOT use "sharia requires" when the claim is specific to one standard.
* DO NOT paraphrase the disclaimer.
* DO NOT issue the report without the `limits` section.

## Example Output
See the structure above. A complete report always contains all required envelope fields for every subject; a subject with missing fields must be marked `insufficient_data` rather than omitted.
