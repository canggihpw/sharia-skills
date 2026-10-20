---
name: sharia-finance-principles
description: "Use when explaining why an Islamic finance structure is or is not permissible, when a question spans several contract types, or when another sharia skill needs the underlying fiqh principle before applying a procedure — covers riba, gharar, maysir, risk-return doctrine, and the contract taxonomy."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Finance Principles

## Purpose
Provide the reasoning frame every other skill in this pack depends on: the prohibitions (riba, gharar, maysir, haram subject matter), the ownership-and-risk principles that legitimise profit, and the contract taxonomy used to classify any structure. This skill is behavioural — it produces an explanation, not a document artefact.

**Input chain:** optional governing standard (AAOIFI, DSN-MUI, SC Malaysia, index provider). If unnamed, the skill states its default and labels it as an assumption.

## When to Use
* User command: `/sharia-finance-principles`
* Autonomous trigger: a request asks "why" a structure is permissible/non-permissible; a question spans more than one contract type; a verdict needs justification rather than procedure; another sharia skill must resolve a principle before applying a ratio.
* Not for: running a screening (use `sharia-stock-screening`) or calculating zakat (use `sharia-zakat-calc`).

## Prerequisites & Context Gathering
Read before reasoning:

1. `references/prohibitions.md` — riba, gharar, maysir, haram subject matter, and the ownership principles.
2. `references/contracts.md` — the contract taxonomy and per-contract conditions.
3. `references/precedence.md` — which standard governs when standards disagree.
4. `references/thresholds.yaml` — quantitative limits, if the question turns on a ratio.

Establish, or explicitly assume:
* What structure is actually in play (not what it is called).
* The governing standard or scholarly authority.
* Whether the user wants an explanation or a ruling.

## Execution Workflow

### Step 0: Refresh contested-status facts (web search)

Before reasoning about a contested item (crypto, digital gold, tobacco, organised tawarruq), search for the current position rather than relying on training data. Record `as_of` and source.

- `fatwa DSN-MUI <topic> <year>` (Indonesia)
- `AAOIFI <topic> update`
- `OJK <topic> <year>`

For settled principles (riba, gharar, maysir) no search is needed. For anything whose permissibility is disputed, it is mandatory.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`. If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Name the structure
Identify the contract or arrangement from its cash flows: who provides capital, who works, who owns the asset, who bears loss, what the return attaches to. Map it to `references/contracts.md`. Most errors come from analysing the marketing label instead of the economics.

### Step 2: Identify the economic substance
Write the sequence in plain language: purchase, ownership period, transfer, payment, penalty. If the sequence reduces to "money now, more money later with a guarantee", the label does not matter.

### Step 3: Test against the prohibitions
Apply, in order:
1. Is the return guaranteed and detached from risk? — riba indicator.
2. Is the object, price, or outcome materially unknown? — gharar indicator.
3. Is the gain zero-sum against another participant? — maysir indicator.
4. Is the underlying activity prohibited? — subject-matter test.
5. Does return follow risk (`al-ghunm bil-ghurm`)? — legitimacy test.

A "guaranteed-looking" markup can still be permissible in murabaha, because the financier owned the asset and bore risk in between. Test the sequence, not the number.

### Step 4: Apply the governing standard
Where a threshold or permitted variant is involved, use `references/thresholds.yaml` and cite the standard by name and edition. Do not mix standards in one answer.

### Step 5: Separate settled from contested
Label each finding as consensus, majority, minority, or contested. For contested matters (tobacco, weapons, crypto, organised tawarruq, bay' al-'inah), give the positions rather than a single answer.

### Step 6: Emit the answer
Lead with the principle, then the application to this case, then the caveat. Use the envelope in `references/output-contract.md` for structured output.

## Output
A short reasoned answer with:
* structure classification,
* the test applied and its result,
* governing standard and citation,
* what is contested,
* escalation flag if the case is novel or material.

## Constraints & Guardrails
* DO NOT judge the label instead of the cash flows.
* DO NOT reduce compliance to a single ratio — the business-activity screen comes first.
* DO NOT present a fatwa as universally binding; it binds its jurisdiction or adopter.
* DO NOT treat a sharia certificate as proof that a specific transaction matches the certified structure.
* DO NOT conflate ordinary investment risk with maysir.
* DO NOT issue a fatwa. If the user asks for a religious ruling, say this is informational analysis and direct them to a qualified scholar or the institution's sharia supervisory board.
* DO NOT omit the standing disclaimer in user-facing output.

## References
- **Qur'an** — 2:275–279 (riba), 4:29 (mutual consent), 5:90 (maysir), 17:26–27 (israf).
- **Hadith** — *Sahih Muslim*, Kitab al-Musaqah, riba chapters; *Sahih al-Bukhari*, Kitab al-Buyu'.
- **Standard** — AAOIFI, *Shari'ah Standards*, current ed., SS 21 (Financial Paper) and SS 31 (Gharar).
- **Classical fiqh** — Ibn Rushd, *Bidayat al-Mujtahid*; Al-Shatibi, *Al-Muwafaqat*.
- **Modern scholarship** — Kamali, *Shari'ah Law: An Introduction* (Oneworld, 2008); El-Gamal, *Islamic Finance* (Cambridge, 2006).
- Full bibliography and citation rules: `references/sources.md`. Verify the current edition before relying on a standard.

## Example Output
```markdown
Structure: murabaha (cost-plus sale) — financier buys the asset, owns it briefly, sells to the customer at disclosed cost + markup.

Why it can be permissible: the return attaches to a real sale, and the financier bears ownership risk between purchase and resale (al-ghunm bil-ghurm).

Where this one fails: the documents show the financier never took delivery and the asset was never at its risk; the cash flow is a disbursement plus a time-based markup. That is a loan, not a sale.

Standard: AAOIFI Standard No. 21 / DSN-MUI 80/2011 — but this is a structure question, not a ratio question, so the ratio tests do not rescue it.

Contested: no. Escalate: no, unless the counterparty disputes the delivery sequence.

Note: informational screening, not a fatwa.
```
