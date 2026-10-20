---
name: sharia-bank-product-review
description: "Use when the user asks whether a specific Islamic bank product is genuinely compliant, compares syariah and conventional products, or questions a product's fatwa backing — traces the akad, ownership sequence, fee and penalty treatment, and deposit guarantee mechanics."
version: 1.1.0
author: Sharia Skills
---

# Skill: Bank Product Review

## Purpose
An Islamic bank is an institution; a product is a structure. This skill reviews the structure behind a retail or commercial product and separates genuine risk-sharing from a conventional product with an Arabic name.

## When to Use
* User command: `/sharia-bank-product-review`
* Autonomous trigger: "is this syariah mortgage really syariah", comparing Islamic and conventional products, checking a product's fatwa claim, or reviewing a deposit, card, or financing product.
* Not for: reading the full contract clause by clause (use `sharia-contract-review`).

## Prerequisites & Context Gathering
1. Identify the product and its stated akad. If no akad is stated, that is finding number one.
2. Obtain the product disclosure sheet, fee schedule, and fatwa reference.
3. Read `references/contracts.md` for the akad conditions.
4. Determine the governing standard and the local regulator.

## Execution Workflow

### Step 0: Refresh product, rule, and fatwa (web search)

- `<bank> <product> akad`
- `<bank> <product> brosur <year>` or product disclosure sheet
- `POJK 4 Tahun 2026` (investment products) and `POJK 11 Tahun 2023` (spin-off)
- `fatwa DSN-MUI <akad> <year>`
- `OJK pedoman produk bank syariah <year>`

Products are repriced and restructured. Verify the current version before judging the structure.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`. If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Map the product to an akad
| Product | Typical akad | Watch for |
|---|---|---|
| Home financing | Murabaha, IMBT, musharakah mutanaqisah | Whether the bank ever owned the property |
| Auto financing | Murabaha, IMBT | Ownership before sale; penalty treatment |
| Personal financing | Murabaha, tawarruq | Organised tawarruq; commodity sequence |
| Working capital | Murabaha, musharakah | Real trade vs cash advance |
| Savings account | Wadiah, mudarabah | Profit must not be guaranteed |
| Term deposit | Mudarabah | Profit ratio and loss disclosure |
| Credit card | Kafalah, qard | Late fees that function as interest |
| Takaful | Tabarru' + wakalah | Fund investments; surplus distribution |

### Step 2: Trace ownership and risk
Build a dated timeline: customer identifies asset → bank purchases from supplier → bank owns and bears risk → bank sells or leases to customer → customer pays.

Look for steps skipped on paper but implied by the cash flow. A bank that pays the supplier directly and books a receivable has not owned the asset.

### Step 3: Check the money flows
* **Pricing benchmark** — acceptable if attached to a sale or lease, not to a loan balance.
* **Fees** — fixed service fees are acceptable; fees proportional to the amount financed and recurring are a markup in disguise.
* **Penalty / late fee** — should go to charity. If it accrues to the bank, flag it.
* **Early settlement** — an `ibra'` rebate is common; an early-payoff charge that functions as interest is not.
* **Deposit guarantee** — LPS or a state guarantee is a regulatory safety net, not a bank capital guarantee. Do not present it as part of the akad.
* **Investment-product separation** — Indonesia's POJK 4/2026 (in force 29 April 2026) requires sharia banks to separate investment products from savings, run a suitability assessment, and keep separate management and accounting. A product that commingles funds or skips suitability is non-conforming regardless of its akad.

### Step 4: Verify the fatwa claim
* Which body issued it — national fatwa council, the bank's sharia supervisory board, or an internal committee?
* Does it cover **this product version**? Products change; fatwas lag.
* Is it public? If not, the claim is unverifiable; say so.
* Do the documents match the fatwa's described structure?

A DPS opinion binds the bank's own governance; it is not a universal ruling.

### Step 5: Compare honestly
If the economics are identical to the conventional product — same total cost, same penalty mechanics, same guarantee — say so and state where the structural difference actually is, or that there is none.

### Step 6: Verdict
| Condition | Verdict |
|---|---|
| Documented akad, ownership sequence, charity penalties, no guarantee | `compliant` |
| Structure reduces to a loan, or penalty accrues to the bank | `non_compliant` |
| Plausible but undisclosed, or contested tawarruq | `questionable` |
| Documents or fatwa unavailable | `insufficient_data` |

## Output
The envelope from `references/output-contract.md`, plus the ownership timeline, money-flow findings, fatwa verification status, and a cost comparison against the conventional alternative when relevant.

## Constraints & Guardrails
* DO NOT accept "syariah" branding as evidence of structure.
* DO NOT overlook a conventional loan booked through a different entity in the group.
* DO NOT approve organised commodity murabaha for personal financing without flagging it as contested.
* DO NOT assume the named takaful policy is actually takaful; check the insurer.
* DO NOT ignore profit equalisation reserves that smooth returns into a de facto guarantee.
* DO NOT hide a material cost disadvantage — compliance is necessary, not sufficient.
* DO NOT omit the standing disclaimer.

## Example Output
```markdown
## Product: Bank A Syariah Home Financing
Stated akad: murabaha
Ownership timeline: bank pays developer → same-day sale to customer. No ownership interval, no risk borne.
Penalties: late fee to bank income (clause 9.3).
Fatwa: DPS reference published, but the disclosed structure differs from the fatwa's described two-step sale.
Cost: 1.4% higher total than the conventional equivalent.

Verdict: non_compliant as documented.
Escalate: yes — request the purchase deed evidencing bank ownership.

Informational review, not a fatwa.
```
