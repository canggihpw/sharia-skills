<!-- GENERATED FILE — do not edit. Source: shared/references/output-contract.md. Run `npm run sync`. -->

# Output contract

All skills in this pack emit the same envelope so results can be aggregated,
compared, and audited. Deviating from it is a defect.

## Verdict vocabulary

Use exactly one of:

| Verdict | Meaning |
|---|---|
| `compliant` | Passes every test in the named standard on available data |
| `non_compliant` | Fails at least one test in the named standard |
| `questionable` | Passes some tests, fails none clearly, or depends on a contested item; or data is conflicting |
| `insufficient_data` | A required input is missing and the verdict would be speculative |

Never emit `compliant` on partial data. Never emit `non_compliant` on a disputed
line item alone without labelling it.

## Required fields

```
subject:      what was assessed (ticker, fund, product, contract)
jurisdiction: resolved jurisdiction, and what it governs here
standard:     named standard + edition + date verified
as_of:        date of the underlying financial data
context:      refreshed facts with dates, or "not required" (see context-protocol)
verdict:      one of the four above
ratios:       table of each test: numerator, denominator, value, threshold, pass/fail
activity:     business-activity screen result and any disputed exposures
evidence:     source per input, with the period covered
purification: ratio and amount, or "not applicable"
dissent:      positions where scholars or standards disagree
escalate:     true/false + the specific question a scholar would need to answer
limits:       what this assessment does not cover
```

## Ratio table format

| Test | Value | Threshold | Result | Source |
|---|---|---|---|---|
| interest-bearing debt / total assets | 41.2% | <= 45% | pass | FY2025 10-K, note 14 |

State the denominator explicitly. Do not report a ratio as a bare percentage.

## Citations

Every operative fact and every recommendation carries its source in the output.
Use the hierarchy in `sources.md`:

- **Threshold** — standard, edition, and date verified.
- **Regulator or fatwa** — instrument number, status, and date.
- **Market fact** — value, `as_of`, and source.
- **Religious principle** — verse, or hadith collection and chapter; name the
  fiqh work where the schools differ.
- **Heuristic** — label it as heuristic. Never attribute a planning percentage to
  a scholar, a standard, or a regulator.

If a source cannot be verified, mark it `unverified` and cap the verdict at
`questionable`.

## Wording rules

- Attribute thresholds: "under DSN-MUI 80/2011", not "sharia requires".
- Separate **fact** (reported financials), **inference** (applied formula), and
  **judgement** (contested classification).
- If a number was estimated, mark it `est.` and explain the method.
- Do not use hedging that hides a conclusion: "may potentially be considered
  possibly non-compliant" is not a verdict.
- Do not use confident language where the standard is unverified.

## Standing disclaimer

Include verbatim in any user-facing report:

> This is an informational screening based on the named standard and publicly
> available data. It is not a fatwa, not legal or tax advice, and not a
> substitute for a qualified sharia scholar or your institution's sharia
> supervisory board. Standards differ; a verdict is only meaningful relative to
> the standard cited.

## Escalation triggers

Set `escalate: true` when any of these hold:

- The structure is novel or the documents contradict the described akad.
- The outcome depends on a genuinely contested item and the user's decision is
  material.
- The standard's current edition could not be verified.
- The entity operates in a jurisdiction with no applicable standard and the
  exposure is large.
- The user asks for a religious ruling rather than a compliance screen.
