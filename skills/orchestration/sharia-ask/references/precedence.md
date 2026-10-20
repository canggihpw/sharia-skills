# Standard selection and precedence

Sharia screening is not one algorithm. The same company can be compliant under
DSN-MUI and non-compliant under MSCI Islamic, because the legal bases, ratio
definitions, and denominators differ. A verdict without a named standard is
meaningless.

## Selection order

1. **Explicit user mandate.** If the user is subject to a fund mandate, a
   regulator, or a specific index, that governs.
2. **Local regulator / national fatwa body.** Indonesia: DSN-MUI + OJK.
   Malaysia: SAC. Gulf: AAOIFI is commonly adopted, sometimes with local
   adjustments. Pakistan: SBP / PSX KMI.
3. **Chosen index provider.** If the benchmark is named, use that methodology
   even when it is looser or tighter than the local standard.
4. **AAOIFI default.** Use only when nothing above applies, and say so.

## Jurisdiction first

Before choosing a standard, resolve the jurisdiction from
`references/context-protocol.md`. Screening follows the asset's listing and its
regulator; personal obligations (zakat, purification destination) follow the
investor's residence and chosen authority. When the two differ, report both.

Load the jurisdiction reference (`references/jurisdictions/<country>.md`) and
refresh it by web search before relying on any threshold. Regulatory instruments
are amended, and "the fatwa says X" is not the same as "the operative rule is X".
Indonesia is the clearest case: Fatwa 80/2011 still states 45% and 10%, while
POJK 8/2025 sets a 5% non-halal income cap in force from April 2026 and phases
the debt cap from 45% toward 33%.

## Rules

- Never mix ratios from two standards in one verdict.
- Never average two thresholds.
- If the standard is unstated, ask once; if the user cannot answer, default to
  DSN-MUI for Indonesian assets, AAOIFI otherwise, and label it an assumption.
- Denominators matter: `debt / market cap`, `debt / total assets`, and
  `debt / average market cap` are different tests. State which one you used.
- If the chosen standard's current edition cannot be confirmed, return
  `questionable`, not a confident verdict.
- If a rule is mid-transition, report the fatwa value and the operative value
  separately. Never present a phased target as the current threshold.
- A local authority's published figure (e.g. BAZNAS nisab) overrides this pack's
  defaults.

## Citation format

Every threshold claim should carry:

```
[standard] [edition/article] — [ratio] <= [threshold] ([denominator])
```

Example:

```
DSN-MUI 80/2011 art. 4 — interest-based debt / total assets <= 45%
```

If you cannot produce that citation, you are recalling rather than citing.
Downgrade the verdict to `questionable` and say the citation is unverified.

## What not to do

- Do not invent fatwa numbers, article numbers, or scholar attributions.
- Do not present an index provider's marketing summary as the full methodology.
- Do not treat a `fatwa` as universally binding; it binds its jurisdiction or
  the entity that adopted it.
