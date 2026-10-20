---
name: sharia-market-context
description: "Use when any sharia analysis or recommendation depends on current conditions — market levels, index constituents, regulator changes, nisab, or the status of a contested asset — searches the web, dates every fact, and produces a context brief."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Market Context

## Purpose
Produce a dated, sourced brief of the current conditions that the other skills
depend on. This skill exists because **the pack's static references go stale**:
rules are amended, index constituents are rebalanced twice a year, nisab is reset
annually, and prices move daily. Reasoning from memory produces confident errors.

**Web search is mandatory here.** This is the skill that keeps the pack current.

## When to Use
* User command: `/sharia-market-context`
* Autonomous trigger: any skill in this pack is about to make a verdict or a
  suggestion that depends on a fact newer than its reference file; the user asks
  "what is the current situation"; the user asks for an investing
  recommendation; a jurisdiction is Indonesia and the DES/fatwa status matters.
* Not for: the fiqh reasoning itself (use `sharia-finance-principles`).

## Prerequisites & Context Gathering
1. Resolve the jurisdiction (`references/context-protocol.md`).
2. Identify the asset class: equity, fund, sukuk, bank product, crypto, zakat.
3. Read the jurisdiction file if one exists:
   `references/jurisdictions/indonesia.md`, else `_template.md`.
4. Read `references/thresholds.yaml` for the ratios you will refresh.

## Execution Workflow

### Step 1: Resolve jurisdiction
Order: explicit user statement → asset domicile/exchange → named regulator or
currency → ask once. Record the answer and why.

### Step 2: Run the searches
Use the tables in `references/context-protocol.md`. Search for the **specific
fact**, not the topic. Minimum set for an equity question:

| Fact | Query pattern |
|---|---|
| Index level | `<index> today <month year>` |
| Constituents | `<index> constituents <month year>`; `<exchange> announcement <index>` |
| Regulator rule | `<regulator> <topic> <year>`; `POJK <number>` |
| Fatwa status | `fatwa DSN-MUI <topic> <year>` |
| Issuer financials | `<ticker> annual report <year>` |
| FX and rates | `USD IDR <date>`; `BI rate <date>`; `10Y INDOGB <date>` |

For zakat, add `nisab zakat <year> BAZNAS` and the current gold price.
For crypto, add `OJK DSN-MUI crypto status <year>` and the current fatwa number.

### Step 3: Classify each fact
Label every finding as one of:

* **in force** — operative now
* **phased** — in force but transitioning to another value
* **announced** — decided, not yet effective
* **proposed** — consultation only
* **stale** — could not refresh

This distinction prevents the most common error: repeating a consultation or a
target as if it were current law.

### Step 4: Emit the context brief
```
jurisdiction: Indonesia
as_of:        2026-10-20
asset_class:  equity
facts:
  - ISSI constituents: 578 (BEI, effective 7 Jul 2026) — in force
  - DES non-halal income cap: 5% (POJK 8/2025, effective 25 Apr 2026) — in force
  - DES debt cap: 45% phasing to 33% over 10 years — phased
  - MSCI Indonesia: consultation open, decision by 30 Jun 2027 — proposed
  - IHSG: <value> (<date>)
  - BI rate: 5.75%; 10Y INDOGB: ~7.4% (<date>)
stale:        none
sources:      [primary source per fact]
```

### Step 5: Translate to posture (only if asked)
A market context is not a buy signal. If the user asks "so what should I do",
produce a posture analysis:

* what the conditions are, with dates,
* which risks they create for this user's holdings, currency, and horizon,
* which levers the user controls (allocation, liquidity, time horizon,
  purification, contribution schedule),
* what would need to change for the picture to improve,
* what the evidence does not support — e.g. "cheap valuations do not imply a
  near-term rebound", "past drawdowns do not guarantee recovery".

Never convert this into a price target or a religious ruling.

## Output
The context block, the stale list, and the sources. If used inside another
skill, hand the block back so the verdict can cite it.

## Constraints & Guardrails
* DO NOT answer current-condition questions from memory.
* DO NOT quote a market level, nisab, or constituent count without a date.
* DO NOT treat a consultation, proposal, or phase-in target as current law.
* DO NOT cite a secondary article when the primary regulator document is
  available.
* DO NOT fill a failed search with a plausible number; mark it `stale`.
* DO NOT present a market view as a sharia ruling or investment advice.
* DO NOT recommend a specific security. Give exposure, risk, and process.
* DO NOT omit the standing disclaimer when the brief feeds a user-facing answer.

## Example Output
```markdown
## Context brief — Indonesia, equity, 2026-10-20

Jurisdiction: Indonesia (IDX listing; user resident in Indonesia)
as_of: 2026-10-20
Standard: DSN-MUI + POJK 8/2025 DES criteria

| Fact | Value | Status | Source |
|---|---|---|---|
| IHSG | six-year low after 11.6% and 5%+ daily falls | in force | exchange data, 16-19 Oct 2026 |
| MSCI Indonesia | consultation to Standalone; decision by 30 Jun 2027 | proposed | MSCI, 15 Oct 2026 |
| DES non-halal income cap | 5% | in force 25 Apr 2026 | POJK 8/2025 |
| DES debt cap | 45% → 33% over up to 10 years | phased | POJK 8/2025 |
| BI rate / 10Y INDOGB | 5.75% / ~7.4% | in force | market data, Oct 2026 |
| Nisab (income) | Rp 91,681,728/yr | in force 2026 | BAZNAS SK 15/2026 |

Stale: none.

Posture implications (not advice):
- Index-reclassification risk is unresolved until June 2027; passive flows may
  keep pressure on the market regardless of valuations.
- A 33% debt cap phase-in will shrink the eligible universe; names near the old
  45% line may leave DES without any business change.
- Currency weakness and higher local yields raise the hurdle for equities and
  favour short-duration rupiah sukuk for the cash sleeve.
- What would improve the picture: MSCI reform evidence, fiscal consolidation,
  rupiah stability.
- What the evidence does not support: "cheap means it will rebound".

Informational analysis, not a fatwa or investment advice.
```
