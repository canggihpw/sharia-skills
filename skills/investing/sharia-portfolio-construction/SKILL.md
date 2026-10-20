---
name: sharia-portfolio-construction
description: "Use when building or rebalancing a sharia-compliant portfolio, choosing between Islamic indices, monitoring screening drift, or aggregating purification across holdings — covers universe definition, weighting, impure income tolerance, and re-screen cadence."
version: 1.0.0
author: Sharia Skills
---

# Skill: Sharia Portfolio Construction

## Purpose
Turn a set of individually screened names into a system that stays compliant across price moves, corporate actions, and rebalances. Screening one stock is a test; a portfolio is a control process with a documented mandate.

## When to Use
* User command: `/sharia-portfolio-construction`
* Autonomous trigger: constructing a new portfolio, rebalancing, selecting an Islamic benchmark, or reviewing drift and purification across a book of holdings.
* Not for: a single-name verdict (use `sharia-stock-screening`) or a fund review (use `sharia-fund-etf-review`).

## Prerequisites & Context Gathering
1. Establish the mandate: governing standard, benchmark, risk tolerance, horizon, liquidity needs, and any extra sector exclusions. If the standard is unstated, ask once — do not build on an assumption.
2. Read `references/precedence.md` to resolve the standard.
3. Read `references/thresholds.yaml` for the screening limits.
4. Read `references/output-contract.md` for the reporting envelope.

## Execution Workflow

### Step 1: Write the mandate
Record in one block: standard, benchmark (ISSI, MSCI Islamic, DJIM, FTSE Shariah, KMI, or none), risk tolerance, horizon, liquidity, purification owner (investor or fund), extra exclusions. This block is the contract for every later decision.

### Step 2: Define the universe
1. Start from benchmark constituents if one exists, else a broad universe.
2. Screen each name with `sharia-stock-screening`; record verdict and data date.
3. Exclude `non_compliant`. Exclude `questionable` unless the mandate explicitly permits a capped sleeve.
4. Sample the largest names by weight, batch the tail, and state the coverage.

### Step 3: Weight
Preferred order:
1. Replicate the benchmark weights — most auditable.
2. Market-cap weight within the compliant universe.
3. Equal weight — less concentration, more turnover.
4. Optimised — only with explicit sharia constraints inside the optimiser, never as a post-hoc filter.

No shorting, no leverage, no mean-variance optimisation that requires either.

### Step 4: Set impure-income tolerance
Decide and document: maximum aggregate impure revenue, whether a single name may carry up to its standard's limit, and whether a residual <1% tracking-error position is tolerated. A tolerance that is never checked is not a control.

### Step 5: Define rebalancing and drift triggers
* **Periodic** — quarterly or semi-annual re-screen matching the benchmark.
* **Price-driven** — market cap changes alter debt ratios; watch names within 20% of a threshold.
* **Event-driven** — mergers, spin-offs, new debt issuance, segment changes, dividend suspensions.
* **Index reconstitution** — match the provider's schedule.

On breach: exit within a defined window and purify income received while holding. Do not hold a breached name "until it recovers".

### Step 6: Aggregate purification
`sum(distributions_received x holding_purification_ratio)`. Keep a dated ledger. Delegate per-holding maths to `sharia-purification-calc`. Report the total separately from performance.

### Step 7: Handle cash
Idle cash goes to an Islamic money market instrument or commodity murabaha. If a conventional account is used because no Islamic option exists, state it and purify the interest.

## Output
A portfolio table (name, weight, verdict, standard, data date, purification ratio), a compliance summary (compliant / questionable / non-compliant weights), the rebalance schedule, and the purification ledger format.

## Constraints & Guardrails
* DO NOT screen once at inception and never again.
* DO NOT treat an Islamic index as a perpetual compliance guarantee.
* DO NOT ignore market-cap-driven ratio drift.
* DO NOT let cash sit in a conventional sweep and call the portfolio compliant.
* DO NOT produce a single blended purification ratio that cannot be reproduced from holdings.
* DO NOT use derivatives for "hedging" without checking the mandate and the standard.
* DO NOT build the portfolio on an unstated standard.
* DO NOT omit the standing disclaimer.

## Example Output
```markdown
## Mandate
Standard: DSN-MUI | Benchmark: ISSI | Horizon: 5y | Purification: investor-level
Extra exclusion: none

## Holdings
| Name | Weight | Verdict | Data date | Purification |
|---|---|---|---|---|
| TLKM | 9.2% | compliant | FY2025 | 2.1% |
| ASII | 7.4% | compliant | FY2025 | 4.0% |
| BBCA | 0% | non_compliant | FY2025 | — |

Compliance summary: 94% compliant, 4% questionable, 2% cash (Islamic money market).
Re-screen: quarterly + on corporate action.
Purification ledger: maintained per distribution, not blended.
```
