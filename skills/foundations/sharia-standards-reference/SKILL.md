---
name: sharia-standards-reference
description: "Use when choosing which sharia standard governs a screening verdict, comparing thresholds across AAOIFI, DSN-MUI, SC Malaysia SAC, MSCI Islamic, Dow Jones Islamic Market, and FTSE Shariah, or when a report needs a proper citation instead of an assertion."
version: 1.0.0
author: Sharia Skills
---

# Skill: Sharia Standards Reference

## Purpose
Select, compare, and cite the standard that governs a verdict. Every other skill in the pack defers to this one for "which rule applies" and "how do I cite it". Produces no artefact; it supplies the governing standard and its citation line.

Sharia screening is not one algorithm. The same company can be compliant under DSN-MUI and non-compliant under MSCI because the denominators, ratio definitions, and activity lists differ.

## When to Use
* User command: `/sharia-standards-reference`
* Autonomous trigger: any screening or review where the standard is unstated; the user names a regulator (OJK, SAMA, SBP) or an index (ISSI, KMI, MSCI); two plausible standards disagree; a report needs a citation rather than a claim.
* Not for: computing a ratio (use `sharia-company-financial-review`) or applying a screen (use `sharia-stock-screening`).

## Prerequisites & Context Gathering
1. Read `references/precedence.md` for the selection order.
2. Read `references/thresholds.yaml` for the thresholds, bases, and confidence levels.
3. Establish the user's jurisdiction, mandate, or benchmark. Ask once if absent.

## Execution Workflow

### Step 1: Determine the governing standard
Apply precedence in order:
1. Explicit client mandate.
2. Local regulator or national fatwa body (Indonesia: DSN-MUI + OJK; Malaysia: SAC; Gulf: AAOIFI, sometimes with local adjustments).
3. Named index provider.
4. AAOIFI default.

If nothing applies, default and label the assumption. Never silently pick the loosest standard.

### Step 2: Read the basis, not just the number
Confirm the denominator: `debt / market cap`, `debt / total assets`, or `debt / average market cap` are different tests. Confirm the revenue definition. Confirm whether interest income is inside or outside the non-permissible revenue cap.

### Step 3: Check confidence and recency
For each threshold used, read the `confidence` field. If `medium`, or the current edition cannot be confirmed, cap the verdict at `questionable` and say why.

### Step 4: Detect and report divergence
If two plausible standards give different answers, produce a comparison table and state which governs and why. Do not average, and do not silently prefer one.

### Step 5: Emit the citation
Canonical form:

```
[standard] [edition/article] — [ratio] <= [threshold] ([denominator])
```

If you cannot produce that line from a verified source, downgrade the claim.

## Output
A governing-standard statement, a comparison table when standards diverge, and one citation line per threshold used.

```markdown
Governing standard: DSN-MUI 80/2011 (Indonesian listing, OJK-regulated fund).
Divergence: the same issuer passes DSN-MUI (debt 41% vs 45%) and fails MSCI (41% vs 33.33%).
Citation: DSN-MUI 80/2011 art. 4 — interest-based debt / total assets <= 45%
```

## Constraints & Guardrails
* DO NOT invent fatwa numbers, article numbers, or scholar attributions.
* DO NOT mix ratios from two standards in one verdict.
* DO NOT average thresholds.
* DO NOT present an index provider's marketing summary as the full methodology.
* DO NOT treat a fatwa as universally binding.
* DO NOT return `compliant` when the standard's current edition is unverified.
* DO NOT omit the standing disclaimer in user-facing output.

## Example Output
```markdown
Q: Is TLKM compliant?

Governing standard: DSN-MUI 80/2011 (IDX listing, Indonesian mandate).
Tests applied:
| Test | Value | Threshold | Result |
|---|---|---|---|
| interest-based debt / total assets | 18.4% | <= 45% | pass |
| interest income / total revenue | 2.1% | <= 10% | pass |
Business activity: telecommunications, no excluded core activity. No disputed exposure above threshold.

Verdict: compliant under DSN-MUI. Under MSCI Islamic the debt ratio would also pass (18.4% vs 33.33%), so this result is robust across standards.

Citation: DSN-MUI 80/2011 art. 4 — interest-based debt / total assets <= 45%

Informational screening, not a fatwa.
```
