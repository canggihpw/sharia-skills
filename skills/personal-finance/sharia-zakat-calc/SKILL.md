---
name: sharia-zakat-calc
description: "Use when the user asks how much zakat they owe, whether an asset is zakatable, whether nisab is met, or how to value cash, gold, stocks, business inventory, receivables, or long-term debt — produces a reproducible worksheet with the chosen basis."
version: 1.1.0
author: Sharia Skills
---

# Skill: Zakat Calculation

## Purpose
Compute zakat on net zakatable wealth: 2.5% after one lunar year, if the base reaches nisab. The rate is easy; the base is where errors happen. Output is a worksheet the user can audit and reuse next year.

## When to Use
* User command: `/sharia-zakat-calc`
* Autonomous trigger: annual zakat computation, a question about whether an asset is zakatable, nisab testing, or valuing shares, gold, inventory, or crypto.
* Not for: purification of impure investment income (use `sharia-purification-calc`). They are different obligations and can both apply.

## Prerequisites & Context Gathering
1. Read `references/thresholds.yaml` under `zakat_defaults` for nisab and rate defaults.
2. Establish, or assume with a label:
   * Nisab basis — gold (85 g) or silver (595 g). Prefer silver for cash and financial assets; it is lower and more inclusive.
   * Local authority — e.g. BAZNAS in Indonesia, state zakat boards elsewhere; if they publish a currency nisab, use it and date it.
   * Madhhab or authority for the disputed items below.
3. Obtain a valuation date and asset prices on that date.

## Execution Workflow

### Step 0: Refresh nisab and prices (web search) — mandatory

- `nisab zakat <year> BAZNAS` or `SK Ketua BAZNAS nisab <year>`
- `harga emas Antam hari ini` or `harga perak hari ini`
- `<local authority> nisab <year>` if outside Indonesia

Currency nisab is reset annually and gold prices move daily. Never use a figure from a previous year without saying so.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`. If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Build the asset base
| Asset | Zakatable amount |
|---|---|
| Cash and bank balances | Full balance |
| Foreign currency | Converted at the valuation date |
| Gold bullion, coins, bars | Market value |
| Gold jewellery | Per madhhab: Hanafi includes; the other three generally exclude personal-use jewellery |
| Silver | Market value |
| Stocks — trading intent | Market value |
| Stocks — long-term investment | Market value, or the company's zakatable assets pro rata; state which |
| Funds / ETFs | Look through if possible, else market value |
| Sukuk | Market value |
| Business inventory | Current market value, not cost |
| Trade receivables | Collectible amounts; doubtful debts excluded |
| Rental property | Zakat on net rental income, not the property (majority) |
| Agricultural produce | Separate ushr rules, not 2.5% |
| Livestock | Separate schedule, not 2.5% |
| Crypto | Contested; present positions, do not assume |
| Primary residence, personal car, furniture | Not zakatable |
| Business fixed assets | Not zakatable |

### Step 2: Deduct current liabilities
Deduct only what is due and payable now: current payables, credit card balance due, rent due, tax due, debts payable within the coming year. Do not deduct the full outstanding mortgage — only the current instalment under the common view; note where scholars allow the full debt. Do not deduct projected living costs.

### Step 3: Test nisab
```
net_zakatable = zakatable_assets - current_liabilities
nisab_value   = 595 g silver x silver_price_per_gram   (default)
                or 85 g gold x gold_price_per_gram     (alternative)
if net_zakatable >= nisab_value and hawl_complete:
    zakat = net_zakatable * 0.025
```

**A local authority's published figure overrides the default.** Indonesia: BAZNAS SK No. 15/2026 sets 85 g gold (14 karat, 2025 average price) = **Rp 91,681,728/year or Rp 7,640,144/month** for zakat on income and services. That is a gold basis, not the silver default — use it for Indonesian users and cite the decision number and year.

### Step 4: Apply the hawl
One lunar year (354 days) from the date wealth first reached nisab. Use the lunar year, not 365 days. If wealth drops below nisab mid-year, the hawl restarts under the majority view.

Practical method: fix an Islamic date each year (e.g. 1 Ramadan), value assets on that date, and pay. Consistency beats precision.

### Step 5: Present the worksheet
Every inclusion and exclusion must be visible, with sources and dates.

## Output
```markdown
as_of:            2026-03-01
nisab_basis:      silver, 595 g @ IDR 15,000/g = IDR 8,925,000
zakatable_assets: IDR 250,000,000
current_debts:    IDR 30,000,000
net:              IDR 220,000,000
rate:             2.5%
zakat:            IDR 5,500,000
hawl:             complete (since 2025-03-02)
```

## Constraints & Guardrails
* DO NOT use the Gregorian year for hawl.
* DO NOT deduct the entire long-term mortgage.
* DO NOT value inventory at cost.
* DO NOT mix purification with zakat.
* DO NOT apply 2.5% to gross income instead of net wealth.
* DO NOT use an undated nisab or asset price.
* DO NOT choose silently between gold and silver nisab when the choice changes the answer; show both.
* DO NOT apply the silver default where the user's authority publishes a gold-based nisab.
* DO NOT omit the standing disclaimer.

## Example Output
See the worksheet above, followed by:

```markdown
Disputed items encountered:
- Gold jewellery (personal use): included here under the Hanafi view; excluded under the majority of the other schools. If excluded, net falls to IDR 205,000,000 and zakat to IDR 5,125,000.
- Long-term mortgage: only the current instalment deducted.

Informational calculation, not a fatwa. Confirm with your local zakat authority.
```
