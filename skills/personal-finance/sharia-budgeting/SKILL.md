---
name: sharia-budgeting
description: "Use when the user asks how to allocate household income the sharia way, how much nafkah/zakat/infaq/investment a salary should carry, how to split finances between spouses, or how to set budget floors and caps — produces a priority-tiered monthly allocation with spillover rules."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Household Budgeting

## Purpose
Turn monthly income into an allocation ordered by legal priority, not by
habit. The pack screens what to own and calculates specific obligations; this
skill decides **which obligations and goals get funded first**, what each
category's floor and cap is, and where surplus flows when a category is full.

The output is a reproducible monthly plan with a dated authority line. It is a
budgeting framework, not a fatwa and not investment advice.

## When to Use
* User command: `/sharia-budgeting`
* Autonomous trigger: "how should my family budget the halal way?", "how do we
  split income between nafkah, zakat, emergency fund, and investing?", "how
  much should a salary carry for each category?", "how should spouses split
  finances?", or a request to set budget floors and caps.
* Not for: computing zakat or nisab (use `sharia-zakat-calc`), purifying
  investment income (use `sharia-purification-calc`), choosing holdings (use
  `sharia-portfolio-construction`), or judging a product (use
  `sharia-bank-product-review`).

## Routing
**Routing in:** `sharia-ask` when the request is a household cash-flow question
rather than a screening question. Load `sharia-market-context` when the answer
depends on a current nisab, a local maintenance benchmark, or a change in
zakat rules.

**Routing out:**
* Zakat amount, nisab, or zakatable assets → `sharia-zakat-calc`.
* Impure dividend income → `sharia-purification-calc`.
* Which securities or funds to hold → `sharia-portfolio-construction`,
  `sharia-fund-etf-review`, `sharia-stock-screening`.
* Whether a specific bank product or contract is compliant →
  `sharia-bank-product-review`, `sharia-contract-review`.
* The underlying fiqh reasoning → `sharia-finance-principles`.

This skill does not issue a compliance verdict on any product and does not
compute an obligation.

## Prerequisites & Context Gathering
1. Read `references/thresholds.yaml` under `budgeting_defaults` for the default
   tiers, floors, caps, and spillover order. Treat every percentage as
   configurable.
2. Read the household-obligation section of `references/contracts.md` for the
   nafkah, i'anah, and infishal al-maliyah framing.
3. Read `references/glossary.md` for *nafkah*, *ma'ruf*, *qawwam*, *israf*,
   *hajiyyat*, and *daruriyyat* so the plan uses consistent terms.
4. Read `references/output-contract.md` for the standing disclaimer.

Gather, or assume with an explicit label:

| Input | Why it matters |
|---|---|
| Net monthly income per spouse, and whether it is stable or variable | Fixes the budget basis |
| Household composition and dependants | Sets the nafkah floor |
| Fixed obligations: debt instalments, parents' support, school fees | Tier 1 is actual, not a percentage |
| Current emergency-fund balance and monthly core expenses | Tests the 3–6 month floor |
| Existing investments and worship savings targets | Sets tier 4 and tier 5 requests |
| Jurisdiction and chosen authority | Governs nisab and the maintenance benchmark |
| Currency | All amounts stay in one currency |

Ask for missing inputs **once**, then proceed with labelled assumptions. Do not
run a plan on an unstated jurisdiction if the answer changes the floors.

## Execution Workflow

### Step 0: Refresh dated inputs (web search) — mandatory

- `nisab zakat <year> BAZNAS` or `<local authority> nisab <year>`
- `nafkah ma'ruf <authority> <year>` or `standar nafkah keluarga <year>`
- `upah minimum provinsi <year>` — a dated reference point only, never the floor itself
- `harga pangan <month year>` or the local inflation print, if the user's costs are moving
- `<local authority> fatwa zakat penghasilan <year>` where income zakat applies

Record `as_of` and source for every figure. Do not quote a nisab, a minimum
wage, or a benchmark from memory. If a search fails, say so, label the figure
as stale, and downgrade the plan to a framework-only output.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`.

### Step 1: Fix the basis
1. Use **net** monthly income, after tax and mandatory contributions.
2. Record each spouse separately. Do not merge the wife's income into the
   household pool unless she has voluntarily agreed to contribute.
3. For variable income, average the last three months and label the basis
   `est.`; keep a low-month plan as the floor.
4. State the currency and the planning month.

Choose the budget basis explicitly:
* **Husband-obligated budget** — the husband's income carries nafkah and the
  shared tiers; the wife's income is planned separately. This is the default
  when the household follows spousal separation.
* **Joint pool** — both incomes are pooled by explicit agreement; the wife's
  contribution is still recorded as voluntary.

### Step 2: Establish the floors before the waterfall
Compute the minimum the plan must clear before any discretionary allocation:

* **Tier 1** — actual zakat accrual, parents' support, and halal debt
  instalments. These are obligations, not percentages.
* **Tier 2** — nafkah at *ma'ruf*: housing, food, clothing, health, education,
  and dependants. Use the local benchmark and the household's real costs, not
  the default percentage alone.
* **Tier 3** — emergency reserve of at least three months of core expenses.

If the floors exceed income, stop the waterfall and output a **deficit plan**:
list the shortfall, the obligations that cannot be reduced, and the categories
that must wait. Do not fund investment or lifestyle first.

### Step 3: Run the priority waterfall
Allocate in this order. Degrees are the default framing, not universal law.

| Priority | Category | Degree | Default floor / cap |
|---|---|---|---|
| 1 | Syar'i obligations: zakat, parents' support, halal debt | Wajib | Actual amount / no cap; review above 35% |
| 2 | Family nafkah: household and wife's allowance | Wajib fardhu 'ain (husband) | 40% / 60% |
| 3 | Financial resilience: emergency fund, protection | Wajib konseptual — a planning label, not a fifth fiqh category | 10% / 20%, and 3–6 months of expenses |
| 4 | Long-term investment | Sunnah / hajiyyat | 5% / 30% |
| 5 | Infaq and worship goals: qurban, umrah, sadaqah | Sunnah | 2.5% / 10% |
| 6 | Lifestyle and recreation | Mubah | 0% / 30% |

Zakat is computed on wealth, not income. Carve out a monthly accrual here and
send the actual computation to `sharia-zakat-calc`; do not apply 2.5% to salary
as if that were zakat.

The ranges are heuristic starting points. Label them as such in the output and
allow the user or their authority to replace them.

### Step 4: Apply floors and caps
For each category compute `floor_amount` and `cap_amount`, then mark the status:

| Status | Condition | Action |
|---|---|---|
| `under` | Below floor | Fill from surplus before funding any lower tier; warn |
| `within` | Between floor and cap | No action |
| `over` | Above cap | Route the excess by the spillover order |
| `uncapped` | Tier 1 obligation | Allowed, but warn above the review threshold |

Boundary rules:
* An under-floor tier blocks every lower discretionary tier until it is filled.
* A below-floor emergency fund (under three months) redirects spillover to
  resilience and holds investment at its floor.
* Once the emergency fund reaches its target months, its cap surplus spills
  forward instead of over-funding cash.
* The lifestyle cap is hard. It may only be exceeded by an explicit user
  decision, recorded in the output.
* Tier 1 is never trimmed to make the percentages balance. A plan that does so
  is invalid.

### Step 5: Route the spillover
Follow the order in `budgeting_defaults.spillover.order`:

1. Fill any category still under its floor.
2. Resilience, while below its month target.
3. Long-term investment — the default destination.
4. Infaq and worship goals, up to cap.
5. A named surplus bucket the user has set, such as extra halal debt
   prepayment or a hajj fund.
6. Lifestyle only by explicit opt-in.

Produce a **spillover ledger** with the source category, amount, destination,
and rule applied. Never let a capped surplus silently return to spending.

### Step 6: Separate the spouses' finances (Infishal al-Maliyah)
Present the spouse split as the majority/default position:

* The wife's income is **entirely hers**; the husband has no automatic claim.
* The husband's nafkah is **not reduced** because the wife earns.
* A wife's contribution to household costs is recorded as *i'anah* or sadaqah,
  and is voluntary — never an obligation and never a substitute for nafkah.
* Zakat is computed **separately per spouse**. Hand each computation to
  `sharia-zakat-calc`; do not net one spouse's wealth against the other's.
* Other arrangements are permissible by mutual consent. If the household
  reports one, record it as their chosen arrangement rather than correcting it.

### Step 7: Run the income-earning wife module
Plan her income in three buckets, with no implied obligation:

1. **Independent syar'i obligations** — her zakat and any support she owes.
2. **Voluntary family contribution** — labelled *i'anah*/*sadaqah*, with the
   amount she chooses, including zero.
3. **Independent investment and assets** — her own reserve, investment, and
   worship goals.

Show this as a separate view, not as a second household budget.

### Step 8: Warn, then hand off
Produce gap warnings where any of these hold:
* Nafkah below the *ma'ruf* floor, or a dependant's cost unfunded.
* Emergency fund under three months.
* Zakat not carved out, or an income-zakat obligation unpaid.
* Tier 1 above the review threshold, or obligations consuming the whole income.
* Lifestyle over cap, or investment funded while tier 3 is below floor.
* A capped surplus with no permissible destination.

Then route: zakat maths, purification, and holdings selection to the skills in
the Routing section. Do not drift into them inside this skill.

## Output
1. **Allocation table** — category, degree, amount, % of income, floor, cap,
   status (`under` / `within` / `over` / `uncapped`).
2. **Spillover ledger** — source, amount, destination, rule.
3. **Gap warnings** — the list above, with the specific figures.
4. **Spouse split view** — husband and wife columns; obligation vs voluntary;
   whose zakat is whose.
5. **Authority line** — the default tier set, any overrides, the maintenance
   benchmark with date and source, and the disclaimer from
   `references/output-contract.md`.

Every percentage must be labelled "heuristic default, not a fatwa" unless the
user's authority publishes it.

## Constraints & Guardrails
* DO NOT present the default percentages, floors, or caps as universal law or a fatwa.
* DO NOT reduce the husband's nafkah because the wife earns.
* DO NOT treat the wife's income or contribution as an obligation.
* DO NOT merge spouses' assets or zakat bases by default.
* DO NOT fund tier 4 investment while the emergency fund is below its floor.
* DO NOT let a capped surplus fall back into lifestyle without an explicit decision.
* DO NOT compute zakat, nisab, or purification here; route to the calculator skills.
* DO NOT recommend a broker, fund, ETF, or product; any example is illustrative.
* DO NOT quote a nisab, minimum wage, or maintenance benchmark without a date and source.
* DO NOT trim an obligation to make the allocation percentages balance.
* DO NOT choose an authority silently when it changes the floors.
* DO NOT omit the standing disclaimer.

## References
- **Qur'an** — 4:34 (qawwam), 4:19 (ma'ruf), 65:7 and 2:233 (maintenance according to means), 17:26–27 (israf), 9:60 (zakat categories).
- **Hadith** — *Sahih al-Bukhari* and *Sahih Muslim*, chapters on zakat, maintenance, and spending on family.
- **Classical fiqh** — Al-Shatibi, *Al-Muwafaqat* (maqasid); Ibn Qudamah, *Al-Mughni* (nafkah); Al-Qaradawi, *Fiqh al-Zakah*.
- **Indonesia** — Kompilasi Hukum Islam (KHI), Buku I Hukum Perkawinan, nafkah provisions; BAZNAS SK No. 15/2026.
- **Budgeting method** — the household budgeting literature and the dated local benchmark in Step 0; the percentages are heuristic defaults, not rulings.
- Full bibliography and citation rules: `references/sources.md`.

## Example Output — illustrative only
```markdown
## Allocation — Month: October 2026
Basis: husband's net income, IDR 15,000,000 · Authority: DSN-MUI/BAZNAS (Islamic
monthly nisab and nafkah benchmark checked 2026-10-20) · Defaults: heuristic,
not a fatwa

| Category | Degree | Amount | % | Floor | Cap | Status |
|---|---|---|---|---|---|---|
| Syar'i obligations | Wajib | 2,800,000 | 18.7% | actual | — | within |
| Family nafkah | Wajib fardhu 'ain | 6,750,000 | 45.0% | 40% | 60% | within |
| Financial resilience | Wajib konseptual | 2,000,000 | 13.3% | 10% | 20% | within |
| Long-term investment | Sunnah / hajiyyat | 750,000 | 5.0% | 5% | 30% | within |
| Infaq and worship | Sunnah | 1,500,000 | 10.0% | 2.5% | 10% | within |
| Lifestyle | Mubah | 1,200,000 | 8.0% | 0% | 30% | within |

## Spillover ledger
| Source | Amount | Destination | Rule |
|---|---|---|---|
| Infaq and worship | 500,000 | Financial resilience | capped; emergency fund at 2.4 months, below 3-month floor |
| Financial resilience remainder | — | — | held; investment kept at 5% floor until 3 months |

## Gap warnings
- Emergency fund is 2.4 months, below the 3-month floor; investment is held at its floor.
- Zakat accrual included; the actual nisab and amount must be confirmed with `sharia-zakat-calc`.
- Worship savings request of IDR 2,000,000 exceeded the 10% cap; the excess was not absorbed into lifestyle.

## Spouse split
| View | Amount | Treatment |
|---|---|---|
| Husband — nafkah | 6,750,000 | Obligation; not reduced by wife's income |
| Wife — zakat and personal obligations | 200,000 | Her own; computed separately |
| Wife — voluntary family contribution | 2,000,000 | i'anah/sadaqah; optional |
| Wife — independent investment/assets | 1,500,000 | Her own |

Illustrative framework, not a fatwa, not investment, tax, or legal advice.
Confirm the nisab, nafkah benchmark, and percentages with your chosen authority.
```
