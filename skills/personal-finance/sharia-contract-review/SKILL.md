---
name: sharia-contract-review
description: "Use when the user shares a financing, trade, lease, or partnership agreement and asks whether it is sharia-compliant, or wants red flags in an akad — classifies the contract, traces ownership and risk, and flags clauses that convert a compliant structure into a loan."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Contract Review

## Purpose
Read an actual agreement and determine whether its clauses match the akad it claims to be. Documents reveal structures more honestly than marketing pages, but they still hide the decisive clause in a schedule.

## When to Use
* User command: `/sharia-contract-review`
* Autonomous trigger: a contract, term sheet, or product disclosure is supplied; a "syariah" product's documents need checking; reviewing a partnership or lease before signing; a dispute turns on what the contract said.
* Not for: high-level product comparison (use `sharia-bank-product-review`).

## Prerequisites & Context Gathering
1. Read `references/contracts.md` for the contract taxonomy and conditions.
2. Read `references/prohibitions.md` for the tests.
3. Identify the governing standard via `references/precedence.md`; the same clause may be accepted by one board and rejected by another.
4. Identify the parties, the asset, and the currency.

## Execution Workflow

### Step 0: Refresh the applicable rules (web search)

- `<regulator> <product type> <year>` (e.g. `POJK 4 Tahun 2026 produk investasi perbankan syariah`)
- `fatwa DSN-MUI <akad> <year>`
- `<bank> <product> akad`
- `OJK pedoman produk bank syariah <year>`

Rules and product versions change; a fatwa may not cover the current document. Record the edition and date.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`. If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Classify the contract
Identify the type(s). If it mixes types, name each leg and analyse them separately — do not treat a hybrid as one akad.

If the document calls itself murabaha but the cash flows are a loan, state that. Substance over form.

### Step 2: Answer the six audit questions
1. What is the underlying asset or service? Named, specified, existing?
2. Who owns it, and when? Find the transfer point.
3. Who bears which risk, and when?
4. What is the return attached to — rent, profit share, or sale price?
5. Where do penalties go?
6. Do the documents match the described structure?

### Step 3: Clause checklist by type
**Murabaha**
- [ ] Financier purchased the asset before selling to the customer
- [ ] Cost and markup disclosed
- [ ] Financier bore ownership risk in the interval
- [ ] No penalty interest accruing to the financier
- [ ] No rollover at a new markup that compounds like interest

**Ijarah**
- [ ] Lessor owns the asset for the term
- [ ] Lessor bears structural maintenance and major repair
- [ ] Insurance is takaful, or cost passed through without margin
- [ ] Rent is for usufruct, not for money advanced
- [ ] Transfer of ownership is a separate, later mechanism (IMBT)

**Mudarabah / musharakah**
- [ ] Loss shared per capital ratio
- [ ] No capital guarantee
- [ ] Profit ratio fixed ex ante, not a fixed amount
- [ ] No side letter guaranteeing a return
- [ ] Manager's negligence standard defined

**Salam / istisna**
- [ ] Specification, quantity, quality, and delivery date certain
- [ ] Price fixed
- [ ] Delay penalty does not function as interest
- [ ] Substitution of goods does not shift risk back to the buyer

### Step 4: Flag red flags
Guaranteed capital or fixed return on a partnership; face-value purchase undertaking in musharakah; lessee bearing structural maintenance in ijarah; penalty income to the financier; sale of debt at a discount; two sales in one contract; fees proportional to the amount financed; organised tawarruq with a pre-arranged buyer; conventional insurance inside a takaful structure; simultaneous claims on both the asset and the debt.

### Step 5: Verdict
Use the envelope in `references/output-contract.md`. If the structure is novel or the documents conflict, the answer is "a scholar must review this document", not a clever reinterpretation.

## Output
Contract type and parties; a numbered ownership-and-risk timeline; clause-by-clause findings (compliant / non-compliant / needs clarification); red flags with exact clause references; verdict; escalation decision.

## Constraints & Guardrails
* DO NOT analyse the label instead of the clauses.
* DO NOT ignore the schedules and annexes; that is where guarantees hide.
* DO NOT assume the governing standard; state it.
* DO NOT resolve ambiguity in the counterparty's favour. The correct output is a question to them.
* DO NOT give legal advice. This is a sharia compliance review.
* DO NOT omit the standing disclaimer.

## References
- **AAOIFI** — SS 8 (Murabahah), SS 9 (Ijarah and IMBT), SS 10 (Salam), SS 11 (Istisna), SS 12 (Musharakah), SS 13 (Mudarabah), SS 19 (Qard), SS 30 (Tawarruq), SS 39 (Mortgage), SS 49 (Promises), current edition.
- **DSN-MUI** — fatwa compendium for the relevant akad.
- **Classical fiqh** — Ibn Rushd, *Bidayat al-Mujtahid*; Ibn Qudamah, *Al-Mughni*; Al-Nawawi, *Al-Majmu'*.
- **Primary evidence** — the signed contract, annexes, and disclosure documents.
- Full bibliography and citation rules: `references/sources.md`. Substance over form: test ownership and risk, not the label.

## Example Output
```markdown
## Contract: Home financing agreement, Bank A
Claimed akad: murabaha
Governing standard: DSN-MUI (Indonesian counterparty)

Ownership timeline:
1. Customer selects unit — 2025-02-01
2. Bank pays developer directly — 2025-02-10  ← no evidence of bank ownership
3. Sale to customer at cost + 8% — 2025-02-10  ← same day, no risk interval
4. Deferred payments over 15 years

Findings:
- [non-compliant] No ownership interval: bank never held the asset or bore risk.
- [non-compliant] Late fee accrues to the bank (clause 9.3), not to charity.
- [needs clarification] Takaful provider named, but the policy is a conventional policy (annex B).

Verdict: non_compliant as documented. The economics are a loan with a markup.
Escalate: yes — the counterparty may be able to evidence ownership via a separate purchase deed.

Informational review, not a fatwa or legal advice.
```
