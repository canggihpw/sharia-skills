---
name: sharia-fund-etf-review
description: "Use when the user asks if a mutual fund, ETF, or reksadana is halal, wants a syariah fund or Islamic index ETF checked, or needs a fund compared against its stated screening policy — covers structure, look-through holdings, index methodology, and purification."
version: 1.0.0
author: Sharia Skills
---

# Skill: Sharia Fund and ETF Review

## Purpose
Determine whether a collective investment vehicle is compliant across three dimensions: the **universe** it holds, the **structure** it uses, and the **purification policy** it applies. A compliant-sounding name proves nothing; a "syariah" label may reflect a permissive local screen.

## When to Use
* User command: `/sharia-fund-etf-review`
* Autonomous trigger: "is this ETF halal", "check this reksadana syariah", comparing a fund to an Islamic benchmark, or due diligence before allocating to a fund.
* Not for: a single stock (use `sharia-stock-screening`) or a portfolio of direct holdings (use `sharia-portfolio-construction`).

## Prerequisites & Context Gathering
1. Obtain the prospectus or fact sheet: domicile, legal wrapper, index tracked, holdings disclosure frequency.
2. Obtain the current holdings or top-N weights.
3. Identify the governing standard. If the fund tracks a named Islamic index, that index's methodology governs.
4. Read `references/thresholds.yaml` for the relevant thresholds.

## Execution Workflow

### Step 1: Structure
* **Leverage** — any borrowing, margin, or leverage reset: flag.
* **Derivatives** — futures, options, swaps for hedging or enhancement. Majority view restricts them; record what the fund actually does.
* **Securities lending** — generates fee income and transfers ownership. Contested; flag if material.
* **Short selling** — generally not permitted.
* **Replication** — physical is preferred; synthetic uses swaps and counterparty exposure.
* **Cash management** — Islamic money market or commodity murabaha is acceptable; interest-bearing deposits produce impure income.

### Step 2: Universe and methodology
* If it tracks a published Islamic index (ISSI, MSCI Islamic, DJIM, FTSE Shariah, KMI), apply that methodology.
* If actively managed, it needs a documented screening policy. If the policy is not published, that is `insufficient_data`, not an assumption of compliance.
* Check the **rebalancing frequency**. A quarterly screen can hold a name that has since breached.

### Step 3: Look-through
* Sample-screen the largest holdings with `sharia-stock-screening`; state the coverage as a percentage of NAV.
* Check for outright failures: conventional banks, insurers, alcohol, gambling, and any activity excluded by the governing standard.
* Quantify exposure to non-compliant names and to impure revenue.

### Step 4: Purification policy
| Policy | Assessment |
|---|---|
| Publishes a per-unit purification ratio | Best; use it |
| Purifies internally before distribution | Acceptable; verify the basis |
| No policy, no disclosure | `insufficient_data`; do not assume zero |

A fund that distributes impure income without purification shifts the obligation to the investor. Say so explicitly.

### Step 5: Verdict
| Condition | Verdict |
|---|---|
| Clean universe, no leverage/derivatives, documented purification | `compliant` |
| Holds prohibited names, or uses leverage/derivatives | `non_compliant` |
| Compliant but purification undisclosed, or methodology contested | `questionable` |
| Holdings or policy unavailable | `insufficient_data` |

## Output
The envelope from `references/output-contract.md`, plus: holdings coverage (% of NAV examined), structural feature checklist, purification policy status, and any divergence between the fund's stated policy and the standard the user asked about.

## Constraints & Guardrails
* DO NOT rely on the fund name or a regulatory label alone.
* DO NOT assume zero impure income when purification is undisclosed.
* DO NOT assume index membership guarantees current compliance; index changes lag markets.
* DO NOT ignore securities lending income.
* DO NOT approve a fund of funds without looking through twice.
* DO NOT approve a money market fund without checking that the commodity murabaha sequence is genuine and not reversed tawarruq.
* DO NOT omit the standing disclaimer.

## Example Output
```markdown
## Fund: ABC Islamic Equity ETF (IDX)
Standard: MSCI Islamic methodology (index tracked)
Data as of: 2025-09-30 holdings

Structure: physical replication, no leverage, no derivatives, no securities lending. Cash sweep in an Islamic money market fund. Pass.

Universe: 42 holdings, 96% of NAV examined.
| Check | Result |
|---|---|
| prohibited activities | none in top 20 |
| impure revenue / revenue | 1.8% (weighted) |
| purification policy | per-unit ratio published quarterly |

Verdict: compliant.
Purification: 1.8% of distributions, per the fund's published ratio.
Limits: 4% of NAV not examined; tail holdings could carry a prohibited name.
Escalate: no.

Informational screening, not a fatwa.
```
