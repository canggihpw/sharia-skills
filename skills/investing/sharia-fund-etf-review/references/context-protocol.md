# Context protocol — stay current

Every skill in this pack depends on facts that move. Rules are amended, index
constituents are rebalanced, nisab is reset annually, and prices change daily.
A skill that reasons from its training data will be confidently wrong.

**Therefore: web search is part of the procedure, not an optional extra.** Each
skill's Step 0 names the searches to run. Run them before analysing.

## What must be refreshed, and how often

| Data class | Max age | Search for |
|---|---|---|
| Index level, price, FX, yield | 1 trading day | `<index> today`, `<ticker> price <date>` |
| Index constituents (ISSI, MSCI) | until the next scheduled review | `<index> constituents <month year>`, `<exchange> announcement <index>` |
| Regulator instrument (POJK, SC guidelines) | 90 days | `<regulator> <topic> <year>`, `POJK <number>` |
| Fatwa (DSN-MUI, SAC) | 90 days | `fatwa DSN-MUI <topic> <year>`, `fatwa terbaru <topic>` |
| Screening financials | latest filed period | `<company> annual report <year>`, `<ticker> laporan keuangan` |
| Nisab / zakat rate | current year | `nisab zakat <year> BAZNAS`, `harga emas <date>` |
| Standard edition (AAOIFI, index methodology) | 12 months | `AAOIFI standard <n> update`, `<provider> methodology <year>` |
| Contested asset status (crypto, digital gold) | 90 days | `OJK DSN-MUI <asset> status <year>`, `fatwa <asset>` |

If the newest available source is older than the window, downgrade the verdict
to `questionable` and name what is stale. Do not silently use old data.

## Search procedure

1. **Search for the specific fact, not the topic.** `POJK 8 Tahun 2025 rasio
   utang berbasis bunga` beats `sharia investing Indonesia`.
2. **Prefer primary sources**, in this order: regulator → fatwa body → exchange
   announcement → index provider → issuer filing → reputable financial press.
3. **For every fact, record three things:** the value, `as_of`, and the source.
4. **Classify the status:** announced, in force, phased, or proposed. These are
   not the same and must not be reported as if they were.
5. **If sources conflict**, report both and prefer the primary source.
6. **If the search fails**, say so explicitly. Do not fill the gap from memory.

## Jurisdiction resolution

Resolve before searching, because the answer determines which rules apply.

1. Explicit statement by the user ("I'm in Indonesia").
2. Asset domicile or exchange (IDX → Indonesia; Bursa Malaysia → Malaysia).
3. The regulator or currency the user names.
4. Ask once if it is still unclear.
5. Otherwise default to the broadest applicable standard and label it.

Two different jurisdictions can apply to one request:

* **Screening** follows the asset's listing and the index/regulator that governs
  eligibility.
* **Personal obligations** (zakat, purification destination, which authority the
  user follows) follow the investor's residence and chosen authority.

When they differ, state both. Example: an Indonesian investor holding US stocks
gets MSCI-style screening for the holdings, and BAZNAS/DSN-MUI guidance for
zakat and purification.

## Never hardcode these

* index levels, prices, FX rates, yields
* constituent lists and weights
* nisab in currency
* the current fatwa status of a contested asset
* market sentiment or "the market is bad right now"

Put them in the context block of the output, with dates, every time.

## Output block

Every skill that refreshes context emits this before its verdict:

```
jurisdiction: Indonesia
as_of:        2026-10-20
facts:
  - ISSI constituents: 578 (BEI announcement, effective 7 Jul 2026)
  - DES non-halal income cap: 5% (POJK 8/2025, in force 25 Apr 2026)
  - MSCI Indonesia: consultation open; decision by 30 Jun 2027
  - BI rate: 5.75%; 10Y INDOGB: ~7.4%
stale:        none
sources:      [list]
```

If a fact could not be refreshed, it goes in `stale`, and the verdict is capped
accordingly.

## Turning context into a suggestion

A suggestion is not a price call. When current conditions are poor, the correct
output is a risk-and-posture analysis:

* what the current conditions are, with dates,
* which risks they create for this specific holding or plan,
* which decisions the user actually controls (allocation, currency, liquidity,
  time horizon, purification),
* what would have to change for the picture to improve,
* what the evidence does **not** support (e.g. "cheap valuations mean it will
  rebound").

Never present a market view as a religious ruling. Never present a compliance
verdict as investment advice.
