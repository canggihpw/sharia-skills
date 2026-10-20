---
name: sharia-stock-screening
description: "Use when the user asks whether a stock is halal or syariah-compliant, requests a screening of a ticker, asks why a stock is on or off an Islamic index, or needs a compliance verdict on a listed company — applies business-activity exclusions then financial ratio thresholds under a named standard."
version: 1.0.0
author: Sharia Skills
---

# Skill: Sharia Stock Screening

## Purpose
Produce a defensible compliance verdict on a listed equity: business-activity screen first, financial ratio screen second, purification flag third, all under one named standard. Output is a verdict plus its evidence, not a slogan.

**Input chain:** ticker/exchange, governing standard, data date. The standard may be supplied, inferred from jurisdiction, or defaulted with an explicit label. Financial inputs come from `sharia-company-financial-review` or an equivalent source.

## When to Use
* User command: `/sharia-stock-screening`
* Autonomous trigger: "is X halal", "screen this ticker", "why is X not in ISSI", "check this stock for syariah compliance", or a portfolio skill needs a per-name verdict.
* Not for: funds and ETFs (use `sharia-fund-etf-review`) or extracting the numbers (use `sharia-company-financial-review`).

## Prerequisites & Context Gathering
1. Resolve the ticker and exchange. Beware dual listings and depositary receipts.
2. Determine the governing standard via `references/precedence.md`. If unstated: DSN-MUI for Indonesian listings, AAOIFI otherwise. Say so.
3. Read `references/thresholds.yaml` — use the numbers there, not memory.
4. Obtain current financials. Without them, stop at `insufficient_data`.

## Execution Workflow

### Step 1: Business-activity screen
1. Determine the **core** business from segment reporting, not the company's one-line description.
2. Compare against the `consensus` exclusion list in `references/thresholds.yaml`. Any material presence is `non_compliant` under every standard in this pack.
3. Note `disputed` exposures (tobacco, weapons, music, hotels, crypto) without vetoing on them alone.
4. Look through subsidiaries: a technology company with a lending arm carries riba exposure.
5. Quantify excluded revenue where disclosed.

### Step 2: Financial ratio screen
Apply only the ratios of the governing standard. For each, record numerator, denominator, value, threshold, result, and source period.

1. **Interest-bearing debt ratio** — include short-term borrowings, current portion of long-term debt, long-term debt, finance leases, interest-bearing related-party loans. Exclude trade payables, accruals, deferred tax, provisions.
2. **Interest / non-permissible income ratio** — interest income plus income from other excluded activities, over total revenue. Search the notes and "other income"; it is rarely on the face of the statement.
3. **Cash and interest-bearing securities ratio** (where the standard has one) — cash, deposits, money market, conventional bonds.
4. **Receivables ratio** (DJIM, FTSE) — trade receivables, net.

### Step 3: Verdict
| Condition | Verdict |
|---|---|
| Fails business screen | `non_compliant` |
| Fails any financial ratio | `non_compliant` |
| Passes all, standard verified, data complete | `compliant` |
| Turns on a disputed activity, or data conflicts | `questionable` |
| Required input missing | `insufficient_data` |

### Step 4: Purification flag
If compliant with impure income above zero, state the purification ratio basis and hand off to `sharia-purification-calc`. Passing the screen tolerates the income; it does not clean it.

## Output
The envelope from `references/output-contract.md`: subject, standard, data date, verdict, ratio table, activity screen, evidence, purification, dissent, escalation, limits, disclaimer.

## Constraints & Guardrails
* DO NOT screen from memory. Use current filings or return `insufficient_data`.
* DO NOT mix ratios from two standards.
* DO NOT omit the denominator when reporting a ratio.
* DO NOT treat index membership as a verdict; membership is a periodic provider decision.
* DO NOT treat an Islamic window at a conventional bank as making the parent compliant.
* DO NOT ignore preferred shares with fixed dividends — they are structurally debt-like.
* DO NOT return `compliant` on partial data.
* DO NOT omit the standing disclaimer.

## Example Output
```markdown
## TLKM — PT Telkom Indonesia (IDX)
Standard: DSN-MUI 80/2011 (default for IDX; assumption stated)
Data as of: FY2025 annual report

Business activity: telecommunications and data services. No consensus exclusion. No material disputed exposure.

| Test | Value | Threshold | Result | Source |
|---|---|---|---|---|
| interest-based debt / total assets | 18.4% | <= 45% | pass | FY2025, note 22 |
| interest income / total revenue | 2.1% | <= 10% | pass | FY2025, note 8 |

Verdict: compliant under DSN-MUI.
Purification: 2.1% of dividends received (interest income basis).
Dissent: none material.
Escalate: no.
Limits: no look-through to unconsolidated associates.

Informational screening, not a fatwa.
```
