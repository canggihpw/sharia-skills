---
name: sharia-purification-calc
description: "Use when the user asks how much to purify, how to compute a purification or cleaning ratio, what to do with impure dividend income, or how to keep a purification ledger for a sharia-compliant holding."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Purification Calculation

## Purpose
Compute the amount to give away when a compliant holding carries some impure income. Screening tolerates a small amount of impure revenue; purification removes the benefit. These are separate obligations, and failing to purify is not cured by passing the screen.

## When to Use
* User command: `/sharia-purification-calc`
* Autonomous trigger: a screening verdict is compliant but the impure-income ratio is above zero; a portfolio report needs a purification line; the user asks what to do with a dividend from a mixed-activity company; a fund's purification policy needs checking.
* Not for: deciding whether a holding is compliant (use `sharia-stock-screening`) or computing zakat (use `sharia-zakat-calc`).

## Prerequisites & Context Gathering
1. Confirm the holding is otherwise compliant. Purification does not rescue a non-compliant position.
2. Read the `purification` block in `references/thresholds.yaml` for the governing standard.
3. Obtain the dividend or distribution actually received, and its date.
4. Obtain the impure revenue and total revenue for the matching period.

## Execution Workflow

### Step 0: Refresh the ratio and the distribution (web search)

- `<ticker> purification ratio <year>`
- `<ticker> non-permissible revenue <year>`
- `<fund> purification policy` or `<fund> laporan tahunan`
- `fatwa DSN-MUI 80/2011` (basis: interest income vs non-halal income)

The ratio changes annually. Do not reuse last year's figure. If the fund or issuer does not publish it, return `insufficient_data`.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`. If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Fix the basis
Two common bases:
* `non_permissible_revenue / total_revenue` — AAOIFI, MSCI, FTSE, DJIM.
* `interest_income / total_revenue` — DSN-MUI.

They are not interchangeable. Use the one the governing standard specifies.

### Step 2: Compute
```
purification_ratio  = impure_revenue / total_revenue
purification_amount = amount_received * purification_ratio
```

### Step 3: Decide the scope
* **Dividends vs capital gains** — the majority position purifies the dividend, not the capital gain. Some scholars extend it to the impure component embedded in the sale price. Default to dividends and note the difference.
* **Gross vs net** — use the standard's published ratio; do not recompute on a different denominator to make it smaller.
* **Timing** — purify when the distribution is received, not annually on unrealised gains.
* **Funds** — use the fund's published per-unit ratio. If none, look through to holdings or return `insufficient_data`. Do not invent a blended ratio.

### Step 4: State the destination
Charity, not the company, and not a tax deduction. If the user wants to give it to a specific cause, that is their choice; the obligation is to dispose of it.

### Step 5: Log
Date, holding, ratio, amount, basis, standard. The ledger is what makes next year reproducible.

## Output
```markdown
basis:        DSN-MUI 80/2011 — interest income / total revenue
ratio:        4.0% (FY2025 annual report, note 8)
amount_in:    IDR 2,500,000 dividend received 2025-06-14
amount_due:   IDR 100,000
destination:  charity
note:         capital gains not purified under the default position
```

## Constraints & Guardrails
* DO NOT purify a position that failed the screen.
* DO NOT use the screening ratio as the purification ratio; they answer different questions.
* DO NOT purify on market value instead of distribution received.
* DO NOT apply DSN-MUI's interest-only basis to an AAOIFI mandate, or vice versa.
* DO NOT treat purification as optional because the amount is small — the threshold exists precisely so the amount is small.
* DO NOT call purification zakat.
* DO NOT emit a number when the ratio or the received amount is unknown; return `insufficient_data`.

## Example Output
```markdown
Holding: ASII, 1,000 shares
Dividend received: IDR 2,500,000 on 2025-06-14
Standard: DSN-MUI (IDX holding)
Interest income: IDR 4.0bn; total revenue: IDR 100bn
Purification ratio: 4.0%

Purification due: IDR 100,000 → charity
Capital gains on any sale are not purified under the default position; some scholars differ.

Informational calculation, not a fatwa.
```
