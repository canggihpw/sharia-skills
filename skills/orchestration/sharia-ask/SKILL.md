---
name: sharia-ask
description: "Use when the user does not know which sharia skill to use — 'where do I start?', 'what should I do next?', 'is this halal?', or a request that spans several skills. Resolves the jurisdiction, identifies the real intent, and routes to the right skill with one clear next action."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Ask — Where Do I Start?

## Purpose
Orient the user and route them to the correct skill. This is the entry point for
the pack: it does not screen, calculate, or rule. It works out **what the user is
actually asking**, **which jurisdiction applies**, **what inputs are missing**,
and **which skill to run next** — then hands off with a single action.

**This skill produces no verdict and no calculation.** Its only output is a
routing report.

## When to Use
* User command: `/sharia-ask`
* Autonomous trigger: the user asks "is this halal?" without saying what kind of
  thing; "where do I start?"; "what should I do?"; the request spans several
  skills (e.g. a portfolio question that is really a screening question); the
  user is new to the pack; the correct skill is genuinely ambiguous.
* Not for: a request that already names a clear artefact — if the user says
  "screen BBCA", go straight to `sharia-stock-screening`.

## Prerequisites & Context Gathering
Inspect the request before asking anything. Most routing is answerable from what
the user already said.

1. **What is the object?** A ticker, a fund, a contract, a bank product, an
   amount of wealth, a portfolio, a token, or nothing specific (a concept).
2. **What is the action?** Screen, calculate, review, build, explain, report.
3. **What is the jurisdiction?** Explicit statement → asset domicile/exchange →
   named regulator or currency → ask once. See `references/context-protocol.md`.
4. **What is already provided?** Financials, a prospectus, a contract, a
   holdings list, a zakat date, a resulting document.
5. **Is it time-sensitive?** Anything involving current rules, prices, nisab, or
   index membership needs a context refresh first.

Ask at most **two** questions, and only when the answer changes the routing.

## Execution Workflow

### Step 1: Classify the intent
Map the request to one row. If it spans two rows, route in sequence.

| The user is asking about | Primary skill |
|---|---|
| A specific stock / ticker | `sharia-stock-screening` |
| Where the numbers come from, or a ratio looks wrong | `sharia-company-financial-review` |
| A fund, ETF, or reksadana | `sharia-fund-etf-review` |
| How much impure income to give away | `sharia-purification-calc` |
| A sukuk, or sukuk vs bond | `sharia-sukuk-analysis` |
| Building, rebalancing, or checking a portfolio | `sharia-portfolio-construction` |
| Crypto, a token, staking, or a yield product | `sharia-crypto-token-review` |
| Zakat, nisab, or whether an asset is zakatable | `sharia-zakat-calc` |
| Splitting household income: nafkah, zakat, emergency fund, investing | `sharia-budgeting` |
| A financing, lease, or partnership document | `sharia-contract-review` |
| A specific bank product or "is this really syariah" | `sharia-bank-product-review` |
| *Why* something is permissible or not | `sharia-finance-principles` |
| Which standard applies, or why screeners disagree | `sharia-standards-reference` |
| A term, or mixed Indonesian/Arabic/English wording | `sharia-glossary` |
| Current market conditions, rates, or "should I invest now" | `sharia-market-context` |
| A written compliance report | `sharia-compliance-report` |
| Screening many names at once | `sharia-screening-pipeline` |

### Step 2: Resolve the jurisdiction
Record it and what it governs. Screening follows the asset's listing; zakat and
purification follow the investor's authority. If they differ, say so — that is
often the hidden complication.

### Step 3: Check the inputs
For the routed skill, name what it needs and what is missing:

| Skill | Minimum inputs |
|---|---|
| `sharia-stock-screening` | ticker/exchange, standard, data date, financials |
| `sharia-fund-etf-review` | fund name, holdings or factsheet, index tracked |
| `sharia-sukuk-analysis` | sukuk name or prospectus |
| `sharia-portfolio-construction` | mandate, standard, universe, horizon, risk |
| `sharia-crypto-token-review` | asset, product around it, authority |
| `sharia-zakat-calc` | assets, liabilities, valuation date, authority |
| `sharia-budgeting` | income per spouse, dependants, fixed obligations, emergency fund, targets, authority, currency |
| `sharia-contract-review` | the document |
| `sharia-bank-product-review` | bank, product, disclosure or akad |
| `sharia-compliance-report` | screening evidence already produced |

### Step 4: Decide whether to refresh context first
Route to `sharia-market-context` **before** the analysis skill when the answer
depends on anything dated: current rules, index membership, prices, rates,
nisab, or a contested asset's status. Do not let an analysis skill start on
stale facts.

### Step 5: Report and hand off
Give one primary next action. Offer the second step only as a follow-on, not as
a menu. If the user's request is already precise, skip this skill entirely and
say which skill you are going to run.

## Common routing mistakes

* **"Is this halal?" about a bank product** is not a stock screen. Route to
  `sharia-bank-product-review`, and to `sharia-contract-review` only if a
  document is supplied.
* **"Is my portfolio halal?"** is not one screening. Route to
  `sharia-portfolio-construction`, which then calls the per-name skill.
* **"Should I invest now?"** is two questions: current conditions
  (`sharia-market-context`) and portfolio posture (`sharia-portfolio-construction`).
  Neither produces a buy/sell call.
* **"How much zakat on my stocks?"** needs `sharia-zakat-calc`, not
  `sharia-purification-calc`. They are different obligations.
* **"How should my family budget the halal way?"** is a household cash-flow
  question, not a zakat calculation or a portfolio mandate. Route to
  `sharia-budgeting`.
* **"Why is this haram?"** is `sharia-finance-principles`, not a screening skill.
* **A batch of tickers** is `sharia-screening-pipeline`, not repeated manual
  screens.
* **A user who names a regulator** (OJK, SAC, SAMA) is telling you the
  jurisdiction — use it instead of asking.

## Output
```markdown
## Where to start

**Request:** "Is Bank A's syariah mortgage legit?"
**Object:** bank product · **Jurisdiction:** Indonesia (OJK / DSN-MUI)
**Intent:** verify the akad and the fatwa claim — not a stock screen

**Next skill:** `/sharia-bank-product-review`
**Needs:** bank, product name, disclosure sheet or akad; the fatwa reference if published
**Refresh first:** `sharia-market-context` — check POJK 4/2026 conformity and the current product version

**After that:** `/sharia-contract-review` if you share the actual agreement.

Not investment advice. Informational routing only.
```

## Constraints & Guardrails
* DO NOT screen, calculate, or rule — route.
* DO NOT dump the full skill list; show only the path that applies.
* DO NOT ask more than two clarifying questions.
* DO NOT assume a jurisdiction when the asset or user says otherwise.
* DO NOT send a time-sensitive question straight to analysis without a context refresh.
* DO NOT route a document-based question to a calculator, or a calculation to a document reviewer.
* DO NOT end with a menu of five options; end with one action.
* DO NOT let the user believe a compliance verdict is investment advice.

## References
- **Pack references** — `references/precedence.md` (which standard governs), `references/context-protocol.md` (freshness), and `references/output-contract.md` (reporting).
- **Routing authorities** — AAOIFI, DSN-MUI, OJK, BEI, BAZNAS, and SC Malaysia SAC, as listed in `references/sources.md`.
- **Classical and modern scholarship** — the works listed in `references/sources.md`, for distinguishing principle from operative rule.
- Full bibliography and citation rules: `references/sources.md`. Routing does not itself produce a ruling.

## Example Output — a vague request
```markdown
## Where to start

**Request:** "I want to start investing the halal way."
**Object:** none yet · **Jurisdiction:** Indonesia (stated)
**Intent:** build a compliant process, not screen one name

**Next skill:** `/sharia-market-context`
**Why first:** you need the current DES/ISSI universe, the POJK 8/2025 ratio
phase, and the market's index-review status before choosing anything.

**Then:** `/sharia-portfolio-construction` with your horizon, risk tolerance,
and whether you need liquidity within 12 months.

Two things I need from you: your time horizon, and whether this money is
needed within a year.

Not investment advice.
```
