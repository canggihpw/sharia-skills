---
name: sharia-screening-pipeline
description: "Use when screening many tickers, funds, or products at once, or when a repeatable screening run is needed across a universe — sequences the foundation, screening, review, and reporting skills and defines batch, caching, and failure handling."
version: 1.0.0
author: Sharia Skills
---

# Skill: Sharia Screening Pipeline

## Purpose
Run the whole pack as one repeatable process: establish the standard, gather evidence, screen, purify, report. Without a pipeline, batch screening drifts — different names get different assumptions and the report cannot be compared across rows.

## When to Use
* User command: `/sharia-screening-pipeline`
* Autonomous trigger: more than roughly five subjects to screen; a recurring screen (quarterly, on index reconstitution); a universe-wide pass for a portfolio.
* Not for: one or two names (call `sharia-stock-screening` directly) or assembling the final document (use `sharia-compliance-report`).

## Prerequisites & Context Gathering
1. Read `references/precedence.md` and fix **one** standard for the run. Write it down before any subject is screened.
2. Read `references/thresholds.yaml` for the thresholds.
3. Read `references/output-contract.md` for the per-subject schema.
4. Confirm the subject list, data date, and data source. Deduplicate dual listings.

## Execution Workflow

### Step 0: Refresh the universe and the rule (web search)

- `<index> constituents <month year>` or `ISSI terbaru <month year>`
- `OJK Daftar Efek Syariah <period> <year>`
- `POJK 8 Tahun 2025` (current ratio phase)
- `<regulator> announcement <month year>`

Freeze the run **after** refreshing. A universe pulled from memory invalidates every downstream row.

### Step 1: Freeze the run parameters
```
run_id:       2026-Q1-issi
standard:     DSN-MUI 80/2011
data_as_of:   FY2025 annual reports
universe:     ISSI constituents as of 2025-12-31
purpose:      quarterly compliance review
```
Every later decision inherits this block. Changing it mid-run invalidates comparability.

### Step 2: Screen for obvious exclusions first
Filter out subjects whose core business is prohibited (conventional banks, insurers, alcohol, gambling). Do not compute ratios for them — record the exclusion reason. This is the cheapest step and removes a large share of the universe.

### Step 3: Gather evidence in batch
Invoke `sharia-company-financial-review` per subject. Cache each input table keyed by `(ticker, period)`. Do not re-fetch the same filing for a second ratio.

### Step 4: Apply the screen
Invoke `sharia-stock-screening` per subject using the frozen parameters. Record verdict and the full ratio table. Do not let a subject's individual appeal change the standard.

### Step 5: Handle failures explicitly
| Situation | Action |
|---|---|
| Filing missing | `insufficient_data`, listed in the report |
| Ratio within 10% of a threshold | Flag as **near-threshold**; re-verify the input |
| Data provider disagrees with the filing | Use the filing, record the discrepancy |
| Contested activity is material | `questionable`, not silently compliant |
| Subject delisted or merged | Exclude and note |

Never drop a subject silently. A universe of 100 with 97 results is a finding, not a rounding.

### Step 6: Purify
For compliant subjects with impure income above zero, invoke `sharia-purification-calc`. Aggregate at portfolio level if the run supports a portfolio.

### Step 7: Report
Invoke `sharia-compliance-report` with the full per-subject evidence. Include the run parameters verbatim so the next run can be compared.

### Step 8: Record the run
Persist the run parameters, subject list, verdicts, and data dates. The next run diffs against this one: who crossed a threshold, who was added or removed, and why.

## Output
A batch result table plus the assembled report:

```markdown
| Ticker | Verdict | Debt ratio | Income ratio | Purification | Note |
|---|---|---|---|---|---|
| TLKM | compliant | 18.4% | 2.1% | 2.1% | — |
| ANTM | compliant | 31.0% | 0.8% | 0.8% | near threshold |
| BBCA | non_compliant | — | — | — | business activity |
| XYZ | insufficient_data | — | — | — | FY2025 filing unavailable |
```

## Constraints & Guardrails
* DO NOT change the standard mid-run.
* DO NOT screen from memory, cached memory, or a prior year's result.
* DO NOT omit near-threshold flags; they are the main source of next quarter's surprises.
* DO NOT drop failed subjects from the count.
* DO NOT let parallel execution produce inconsistent assumptions; the frozen parameters bind every worker.
* DO NOT report a batch as compliant because the aggregate percentage looks good.
* DO NOT skip the run record; without it, the next run cannot be diffed.

## Example Output
```markdown
Run: 2026-Q1-issi | Standard: DSN-MUI 80/2011 | Data: FY2025 | 98 subjects

Outcome: 71 compliant, 4 questionable, 21 non-compliant, 2 insufficient data.
Near-threshold: ANTM (debt 31%), PGAS (income 8.1% vs 10%).
Exclusions by reason: conventional finance (14), alcohol (2), insufficient data (2).
Purification total across compliant holdings: 0.9% of weighted distributions.

Full report: generated with sharia-compliance-report.
Next run: quarterly, or on ISSI reconstitution.
```
