---
name: sharia-company-financial-review
description: "Use when extracting or validating the financial inputs behind a sharia screen — interest-bearing debt, interest income, non-permissible revenue, cash and interest-bearing securities, receivables — from an annual report, 10-K, or provider dataset, or when a screening ratio looks wrong and needs evidence."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Company Financial Review

## Purpose
Turn a financial statement into the small set of numbers a screening needs, each with a source and a stated method. This skill produces evidence, not verdicts. It is the difference between a defensible screen and a guess.

## When to Use
* User command: `/sharia-company-financial-review`
* Autonomous trigger: `sharia-stock-screening` needs inputs; a third-party screener's number looks wrong; a ratio sits near a threshold; the user supplies an annual report or 10-K.
* Not for: stating compliance (use `sharia-stock-screening`).

## Prerequisites & Context Gathering
1. Identify the reporting period, currency, and consolidation scope.
2. Identify the denominator basis required by the standard: market cap, total assets, or 24-month average market cap.
3. Read `references/thresholds.yaml` for the ratio definitions in play.
4. Locate the statements: income statement, balance sheet, cash flow, and the notes on borrowings, finance income, segment reporting, and related parties.

## Execution Workflow

### Step 0: Locate the current filing (web search)

- `<ticker> annual report <year> pdf`
- `<ticker> laporan keuangan tahunan <year>`
- `<exchange> financial statements <ticker>`
- `<ticker> bond prospectus` (for debt detail)

Confirm the filing is the latest published period. If only an older report is available, state the lag and mark the affected ratio.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`. If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Fix the period
All inputs must come from one period. Mixing FY2024 revenue with FY2025 debt is a defect; if unavoidable, say so and mark the affected ratio.

### Step 2: Extract interest-bearing debt
Include: short-term borrowings, current portion of long-term debt, long-term debt and bonds, finance lease liabilities, interest-bearing related-party loans, overdrafts.

Exclude: trade and other payables, accrued liabilities, deferred tax, provisions, non-interest-bearing grants.

Cross-check against `total liabilities - non-interest-bearing liabilities`. A large gap versus a data provider's `total debt` usually means lease treatment or a revolving facility.

### Step 3: Extract interest income
Search in order: finance income line, notes to the income statement, "other income" note, cash flow statement interest received, related-party disclosures.

Separate interest from **surplus cash** (impure, often tolerable) from interest from a **lending business** (a business-activity problem, not a ratio problem).

### Step 4: Extract non-permissible revenue
Aggregate excluded-activity revenue from segment disclosures. If a segment is mixed, estimate and prefix `est.` with the method. Do not double count interest income if the standard tests it separately (DJIM has both a 5% ex-interest and a 10% including-interest test).

### Step 5: Extract cash, interest-bearing securities, receivables
Cash and bank balances, short-term deposits, money market funds, certificates of deposit, conventional bonds held. For receivables: trade receivables net of allowance, not financing receivables unless the standard says so.

### Step 6: Validate
* Assets = liabilities + equity.
* Segment revenue sums to consolidated revenue.
* Revenue components sum to reported revenue within rounding.
* Interest paid in the cash flow statement reconciles roughly with debt and disclosed rates.
* Debt is stable across consecutive disclosures; if not, find the reclassification.

If a check fails, report the discrepancy; do not average it away.

### Step 7: Estimate only when necessary
Prefer a disclosed proxy. Otherwise estimate with a stated method. If the estimate could move the verdict across a threshold, return `insufficient_data` and name the missing input. Never estimate silently.

## Output
An input table: value, period, source location, and method (reported / derived / estimated). Then hand off. No verdict.

```markdown
| Input | Value | Period | Source | Method |
|---|---|---|---|---|
| interest-bearing debt | IDR 41.2tn | FY2025 | note 22 | reported |
| total assets | IDR 100.0tn | FY2025 | balance sheet | reported |
| interest income | IDR 2.1tn | FY2025 | note 8 | reported |
| total revenue | IDR 100.0tn | FY2025 | income statement | reported |
| non-permissible revenue | IDR 0.4tn | FY2025 | segment note | est. (mixed segment, 5% allocation) |
```

## Constraints & Guardrails
* DO NOT report a number without a source location.
* DO NOT mix periods or currencies.
* DO NOT estimate silently.
* DO NOT use a provider's `total debt` without checking what it includes.
* DO NOT treat restricted cash as unrestricted without disclosure.
* DO NOT issue a verdict; this skill is evidence only.
* DO NOT reconcile a failed validation by adjusting the number.

## Example Output
See the table above, followed by:

```markdown
Validation:
- assets = liabilities + equity: pass
- segment revenue sums to consolidated: pass (IDR 0.02tn rounding)
- interest paid vs debt: consistent (implicit rate 6.1%)

Open items: none. Ratios are safe to compute.
```
