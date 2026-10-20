---
name: sharia-portfolio-construction
description: "Use when building or rebalancing a sharia-compliant portfolio, choosing between Islamic indices and asset-class sleeves, setting target allocation versus monthly contributions, or aggregating purification across holdings — covers wealth stages, caps, bands, and re-screen cadence."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Portfolio Construction

## Purpose
Turn a set of individually screened names into a system that stays compliant
across price moves, corporate actions, and rebalances. A portfolio has two
layers that are often confused: the **stock** (where total invested wealth
should sit today) and the **flow** (where new money goes this month). Screening
one stock is a test; a portfolio is a control process with a documented
mandate, target weights, and a contribution policy that does not fight them.

## When to Use
* User command: `/sharia-portfolio-construction`
* Autonomous trigger: constructing a new portfolio, rebalancing, choosing
  Islamic indices or asset-class sleeves, setting target weights or a monthly
  contribution split, reviewing drift, or aggregating purification across a
  book of holdings.
* Not for: a single-name verdict (use `sharia-stock-screening`), a fund review
  (use `sharia-fund-etf-review`), a sukuk structure check (use
  `sharia-sukuk-analysis`), or allocating salary between nafkah, zakat, and
  investing (use `sharia-budgeting`).

## Prerequisites & Context Gathering
1. Establish the mandate: governing standard, benchmark, risk tolerance,
   horizon, liquidity needs, total invested wealth, monthly contribution
   capacity, and any extra sector exclusions. If the standard is unstated, ask
   once — do not build on an assumption.
2. Establish the household gate: months of core expenses held in an emergency
   fund, and whether the portfolio is single or joint. If the user has not
   funded the emergency reserve, this skill cannot allocate risk assets yet.
3. Read `references/thresholds.yaml` for `allocation_defaults` (tiers, bands,
   caps) and the screening limits.
4. Read `references/precedence.md` to resolve the standard.
5. Read `references/output-contract.md` for the reporting envelope.
6. If the user also needs an income budget, route that layer to
   `sharia-budgeting`; priority 4 there is the funding source, this skill is
   the destination.

## Execution Workflow

### Step 0: Refresh market and rules (web search) — mandatory

- `<index> today` or `IHSG hari ini`
- `MSCI Indonesia consultation update <month year>`
- `BI rate <month year>`; `10Y INDOGB <month year>`; `USD IDR <date>`
- `ISSI review <month year>`
- `POJK 8 Tahun 2025` (DES ratio phase)
- `<fund/ETF> holdings <month year>` if using funds
- `harga emas <date>` and `sukuk ritel <series> kupon <year>` when those sleeves are used
- `fatwa DSN-MUI <instrument> <year>` for the specific instruments, not for an allocation preference

Market conditions decide the **posture**, not the compliance verdict. Record
`as_of` for every figure. Without a fresh context, give the framework only — no
allocation suggestion.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`.
If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Write the mandate
Record in one block: standard, benchmark (ISSI, MSCI Islamic, DJIM, FTSE
Shariah, KMI, or none), risk tolerance, horizon, liquidity, total invested
wealth, monthly contribution, purification owner (investor or fund), extra
exclusions, and whether spouses invest separately. This block is the contract
for every later decision.

### Step 2: Check the pre-investment gate (Tier 0)
Before any allocation, test the emergency fund:

* **Under 3 months of core expenses** — stop. Build cash first. Output a
  cash-building plan, not a portfolio. Investing is premature regardless of
  expected return.
* **3–6 months** — a starter allocation is permissible, weighted to liquidity.
  Do not add illiquid or high-volatility sleeves.
* **Above 6 months** — proceed to the wealth-stage tier and say which gate was
  applied.

The gate outranks the user's optimism. A plan that funds equities before the
reserve floor is a defect.

### Step 3: Set the strategic allocation (stock)
Choose a wealth-stage tier from `allocation_defaults.tiers`. The default
keying is heuristic; the user may select another tier and state why.

| Tier | Situation | Equity | Sukuk | Money market | Gold | Crypto |
|---|---|---|---|---|---|---|
| 0 | Emergency fund < 3 months | 0% | 0% | 100% cash | 0% | 0% |
| 1 | Horizon < 5y, or wealth < 1x annual core expenses | 25% | 15% | 40% | 15% | 5% |
| 2 | Horizon 5–10y, wealth 1–5x core expenses | 55% | 20% | 10% | 10% | 5% |
| 3 | Horizon > 10y, wealth > 5x core expenses | 55% | 25% | 5% | 10% | 5% |
| 4 | Drawdown or retirement within 5y | 20% | 45% | 25% | 10% | 0% |

Rules:
* Point targets must sum to **exactly 100%**. A range is not a target; if the
  user supplies ranges, convert each to a midpoint and record the band around
  it. Never present a range whose low and high ends each claim to sum to 100%.
* Every sleeve gets a target and a tolerance band, even a 0% one. State the
  band method once — absolute ±5 percentage points by default, or relative
  ±25% of target — and do not mix methods.
* Label every percentage "heuristic default, not a fatwa". The user or their
  mandate overrides it.
* For Indonesia, the default stable sleeve is split: sharia money market for
  liquidity and sukuk for stability and income. DSN-MUI rules on the
  permissibility of instruments, not on allocation weights, so cite the
  instruments' fatwas and treat the split as heuristic.

### Step 4: Map the sleeves and delegate
Each sleeve has a different role and a different skill that owns the verdict.

| Sleeve | Role | Sharia constraint | Liquidity / currency | Delegates to |
|---|---|---|---|---|
| Sharia equities / Islamic index ETF | Growth | Screened universe; no leverage or shorting | Daily–weekly; listing currency | `sharia-fund-etf-review`, `sharia-stock-screening` |
| Sukuk (retail, SNI, PBS, corporate) | Stability / income | Asset-backed structure; tradability depends on tangible assets | Hold to maturity or secondary; issuer currency | `sharia-sukuk-analysis` |
| Sharia money market / RDPU syariah | Liquidity / buffer | Underlying must avoid conventional instruments | Daily; fund currency | `sharia-fund-etf-review` |
| Gold (physical / digital) | Inflation and geopolitical hedge; zakatable | Possession and delivery terms; avoid leveraged or paper-only claims | Physical slower than digital; commodity | `sharia-zakat-calc` for zakat |
| Crypto / BTC | Asymmetric high-risk sleeve, capped | Contested; permissibility is not assumed | Daily but volatile; USD-quoted | `sharia-crypto-token-review` |

Any instrument named in an example is **illustrative**, not a recommendation.
Do not name a broker, fund, or ETF as the preferred vehicle.

### Step 5: Define the contribution policy (flow)
A monthly contribution split is **not** an independent allocation policy. It
must be derived from the target weights and must not contradict them.

* **All sleeves inside their bands** — contribute at the target weights.
* **A sleeve is outside its band** — direct new contributions to the
  underweight sleeve before selling anything. Cash-flow rebalancing is the
  default.
* **A sleeve is above its upper band** — send all new money elsewhere. Sell
  only if the band is still breached after the defined cash-flow window
  (default: two quarters) and the rebalance cannot be closed by contributions.
* **An asset excluded from monthly DCA** — state it explicitly, show how its
  target weight will be reached (scheduled lump sums, windfalls, or not at
  all), and never top it up aggressively. Crypto is the common case.
* **No permanent drift** — if the stated monthly split would move the
  portfolio away from the target, the split is wrong, not the target. Fix the
  split and record the change.

### Step 6: Define the universe
1. Start from benchmark constituents if one exists, else a broad universe.
2. Screen each name with `sharia-stock-screening`; record verdict and data date.
3. Screen each fund or ETF with `sharia-fund-etf-review`; screen each sukuk
   with `sharia-sukuk-analysis`; each token with `sharia-crypto-token-review`.
4. Exclude `non_compliant`. Exclude `questionable` unless the mandate
   explicitly permits a capped sleeve.
5. Sample the largest names by weight, batch the tail, and state the coverage.

### Step 7: Weight within each sleeve
Preferred order:
1. Replicate the benchmark weights — most auditable.
2. Market-cap weight within the compliant universe.
3. Equal weight — less concentration, more turnover.
4. Optimised — only with explicit sharia constraints inside the optimiser,
   never as a post-hoc filter.

Sleeve targets decide how much goes to each sleeve; this step decides how it is
distributed inside the sleeve. Do not let a single attractive name pull the
sleeve past its target.

### Step 8: Apply concentration and cap policy
* **Single-name cap** — default 10% of the portfolio per issuer. Diversified
  funds and ETFs are not single names.
* **Single-sleeve cap** — default 60% of the portfolio. A sleeve at its cap is
  a concentration warning, not a target.
* **Crypto cap** — target 5%, hard cap 10%, upper trigger 15%. At the trigger,
  trim back to target; never top up aggressively. The cap is a risk control,
  not a compliance verdict. Scholarly positions differ; delegate the
  permissibility question to `sharia-crypto-token-review`.
* **Currency** — USD-denominated equity is not a guaranteed rupiah hedge. Size
  the exposure and say what it does and does not protect against.

### Step 9: Set rebalancing bands and drift triggers
Define a numeric band and one method:
* **Absolute** — ±5 percentage points around the target (default).
* **Relative** — ±25% of the target weight (e.g. a 20% target is breached
  below 15% or above 25%).

Triggers:
* **Periodic** — quarterly or semi-annual re-screen matching the benchmark.
* **Band breach** — any sleeve outside its band.
* **Price-driven** — market-cap changes alter debt ratios; watch names within
  20% of a threshold.
* **Event-driven** — mergers, spin-offs, new debt issuance, segment changes,
  dividend suspensions.
* **Index reconstitution** — match the provider's schedule.

On breach: prefer contributions. Sell only when cash flow cannot close the gap
inside the window. Before selling, state the fee, tax, and purification
consequences: selling does not erase impure income already received, and the
ledger must be settled for the holding period. Do not hold a breached name
"until it recovers".

### Step 10: Aggregate purification
`sum(distributions_received x holding_purification_ratio)`. Keep a dated
ledger. Delegate per-holding maths to `sharia-purification-calc`. Report the
total separately from performance. Aggregate only across accounts that belong
to the same owner; see the spousal section.

### Step 11: Handle cash
Idle cash goes to a sharia money market instrument or commodity murabaha. If a
conventional account is used because no sharia option exists, state it and
purify the interest. Cash held for the emergency fund is not part of the
invested portfolio and is excluded from the allocation percentages.

### Step 12: Separate spouses' portfolios
Where two earners invest, model **separate portfolios in separate accounts**
under *Infishal al-Maliyah*:
* separate cost basis and contribution policy,
* separate zakat computation with `sharia-zakat-calc`,
* separate purification ledgers,
* separate risk tolerance and horizon.

Aggregate only for household reporting, with the ownership of each account
labelled. Do not net one spouse's gains against the other's losses, and do not
treat one spouse's assets as collateral for the other's plan. Other
arrangements are permissible by mutual consent; record the one the household
actually chose.

### Step 13: Set the posture from current conditions
Compliance does not depend on the market. Posture does. After the allocation
and weights are compliant, add a dated posture note:

* **Index/classification risk** — if the market is under an index-provider
  review (e.g. MSCI), note the potential forced-flow risk and the decision
  date. Holdings can be compliant and still be repriced by flows.
* **Currency** — unhedged exposure with a weak domestic currency changes the
  real return; sharia-compliant hedging is limited, so size the exposure.
* **Rates** — higher local yields raise the hurdle for equities and make
  short-duration sukuk a credible cash sleeve.
* **Liquidity** — in a stressed market, small-cap constituents may not be
  exitable; cap them.
* **Valuation** — cheap is not a catalyst. State what would change the picture
  (reform evidence, flows, earnings) rather than predicting a rebound.
* **Process** — prefer staged contributions over a single entry when
  volatility is high; re-screen on schedule regardless of price.

Write the posture as risks and levers, not a price target. If the user asks
"should I invest now", answer with the conditions, the risks to their specific
plan, and the decisions they control — and say plainly that this is not
investment advice.

### Step 14: Run the validation checklist
Before emitting output, verify:
- [ ] Target weights sum to exactly 100%.
- [ ] Every sleeve has a target and a band, including 0% sleeves.
- [ ] The monthly contribution split is derived from the targets, or an
      explicit deviation is documented with the reason and the window.
- [ ] Caps sit below the level at which one sleeve or name dominates the outcome.
- [ ] The emergency-fund gate was checked before any risk allocation.
- [ ] Every named instrument is labelled illustrative, not recommended.
- [ ] Spousal accounts, zakat, and purification are separated.
- [ ] Every market figure has an `as_of` date and a source.

If any box fails, fix the plan before presenting it.

## Output
A mandate block; the emergency-gate result and wealth tier; a target-allocation
table (sleeve, target %, band, current %, status, role, delegated skill); a
contribution-policy table (sleeve, target weight, this month's contribution,
reason); a holdings table (name, weight, verdict, standard, data date,
purification ratio); a compliance summary (compliant / questionable /
non-compliant weights); the rebalance schedule; the purification ledger format;
the spouse split; and the dated posture note.

## Constraints & Guardrails
* DO NOT confuse a monthly contribution split with a strategic allocation.
* DO NOT emit target weights that do not sum to exactly 100%.
* DO NOT use a range's low and high ends as if each were a complete allocation.
* DO NOT allocate risk assets before the emergency-fund gate is met.
* DO NOT let a contribution policy drift the portfolio against the targets.
* DO NOT screen once at inception and never again.
* DO NOT treat an Islamic index as a perpetual compliance guarantee.
* DO NOT ignore market-cap-driven ratio drift.
* DO NOT let cash sit in a conventional sweep and call the portfolio compliant.
* DO NOT produce a single blended purification ratio that cannot be reproduced from holdings.
* DO NOT use derivatives for "hedging" without checking the mandate and the standard.
* DO NOT build the portfolio on an unstated standard.
* DO NOT recommend a broker, fund, ETF, or token; examples are illustrative only.
* DO NOT present a crypto cap as a permissibility ruling.
* DO NOT merge spouses' accounts, cost basis, zakat, or purification ledgers.
* DO NOT convert a market view into a buy/sell call or a price target.
* DO NOT let a poor market justify holding a non-compliant name "until it recovers".
* DO NOT quote a market level, yield, or FX rate without a date.
* DO NOT omit the standing disclaimer.

## Example Output — illustrative only
```markdown
## Mandate
Standard: DSN-MUI | Benchmark: ISSI | Horizon: 7y | Wealth tier: 2 (growth)
Total invested wealth: IDR 400,000,000 | Monthly contribution: IDR 3,000,000
Emergency fund: 5.2 months of core expenses (gate passed)
Spouses: separate accounts; husband's plan shown | Purification: investor-level

## Target allocation (stock)
| Sleeve | Target | Band | Current | Status | Role | Delegate |
|---|---|---|---|---|---|---|
| Sharia equities / Islamic index ETF | 55% | 50–60% | 48% | under | Growth | `sharia-fund-etf-review` |
| Sukuk | 20% | 15–25% | 22% | within | Stability / income | `sharia-sukuk-analysis` |
| Sharia money market | 10% | 5–15% | 12% | within | Liquidity | `sharia-fund-etf-review` |
| Gold | 10% | 5–15% | 13% | within | Hedge | `sharia-zakat-calc` |
| Crypto | 5% | 0–10% | 5% | within | High-risk sleeve | `sharia-crypto-token-review` |

Targets sum to 100%. Bands are absolute ±5pp. Percentages are heuristic
defaults, not a fatwa.

## Contribution policy (flow) — this month IDR 3,000,000
| Sleeve | Target | Contribution | Reason |
|---|---|---|---|
| Sharia equities | 55% | 2,400,000 | Underweight; cash-flow rebalance first |
| Sukuk | 20% | 600,000 | At target |
| Money market | 10% | 0 | Within band |
| Gold | 10% | 0 | Within band |
| Crypto | 5% | 0 | Not in DCA; funded only by a scheduled lump sum, never topped up |

## Rebalancing
Method: absolute ±5pp. Re-screen quarterly and on corporate action.
Sell only if contributions cannot close a breach within two quarters.
Fees, tax, and purification consequences stated before any sale.

## Caps
Single name 10% (funds excluded) · single sleeve 60% · crypto target 5%,
hard cap 10%, trim trigger 15% (risk control, not a compliance verdict).

## Spouse split
Separate account, cost basis, zakat, and purification ledger; aggregated for
household reporting only.

Illustrative framework, not a fatwa, not investment, tax, or legal advice.
```
