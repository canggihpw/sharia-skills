---
name: sharia-crypto-token-review
description: "Use when the user asks whether crypto is halal, wants a token, exchange, staking product, or yield product reviewed, or needs the genuine range of scholarly positions on digital assets rather than a single ruling."
version: 1.0.0
author: Sharia Skills
---

# Skill: Crypto and Token Review

## Purpose
Assess a crypto asset or product against the points scholars actually dispute, and report the **range** of positions. This is the most contested area in the pack; a skill that emits a flat halal/haram verdict is harmful.

## When to Use
* User command: `/sharia-crypto-token-review`
* Autonomous trigger: "is Bitcoin halal", reviewing a token, exchange, staking service, or yield product; a portfolio skill encounters crypto exposure.
* Not for: resolving the fiqh dispute itself. That belongs to a scholar.

## Prerequisites & Context Gathering
1. Identify the asset: issuer or decentralised, utility, supply mechanics, backing.
2. Identify the product around it: spot, staking, lending, futures, fund.
3. Ask, or label as unknown, which authority the user follows. The answer changes the verdict.

## Execution Workflow

### Step 0: Refresh the ruling status (web search) — mandatory

The status is moving. Search every time.

- `fatwa DSN-MUI 140/2021 aset kripto`
- `OJK DSN-MUI crypto status <year>`
- `MUI ijtima kripto <year>`
- `<token> sharia review <year>` (for the specific asset)
- `<exchange> sharia certification <year>`

If the authority's current position cannot be confirmed, say so and return a range with `questionable`. In Indonesia, do not assume permissiveness.

### Step 1: State the divergence up front
| Position | Basis | Consequence |
|---|---|---|
| Not mal | No intrinsic value, no physical existence, no state backing | Trading impermissible |
| Mal but not currency | Tradable asset/commodity with conditions | Permissible with qabd, no gharar, no riba |
| Mal and currency-like | Medium of exchange | Currency-exchange rules apply; riba al-fadl risk |
| Permissible with conditions | Accepted asset, activities screened | Token may pass; products may not |

Report which position the user's authority adopts. Do not choose for them.

**Indonesia specifically:** Fatwa 140/DSN-MUI/XI/2021 and the 2021 Ijtima Ulama hold that crypto as currency is haram, and as a commodity is not validly tradable unless it meets sil'ah requirements — physical existence, known quantity, ownership, deliverability, and a clear underlying benefit. OJK's classification work with DSN-MUI was still open in 2026, and the 2021 position remained the government reference. Default to non-compliant in Indonesia, and require the sil'ah test to be evidenced rather than asserted.

### Step 2: Apply the five tests
1. **Mal** — identifiable, usable, transferable wealth? Volatility alone is not disqualifying, but extremes raise gharar.
2. **Gharar** — unknown delivery, unknown price, platform failure. Spot on a reputable exchange differs materially from a leveraged perpetual.
3. **Maysir** — zero-sum price bets, leverage, lottery-like tokenomics. Holding a productive asset is not maysir.
4. **Riba** — the main risk is yield. Validator staking is closer to a service reward; "earn 12% APY on deposited coins" is a loan with a guaranteed return.
5. **Haram activity** — does the token or protocol fund gambling, interest-based lending, or adult content? Screen the use case, not the technology.

### Step 3: Review the product separately
| Product | Issue |
|---|---|
| Spot holding | Depends on the asset position above |
| Validator staking | Service reward; check for guaranteed returns |
| Lending / earning account | Riba if guaranteed |
| Futures / perpetuals | Gharar + maysir + leverage |
| Options | Gharar; majority view restrictive |
| Index or basket token | Look through to constituents |
| NFT | Depends on content and rights |
| Tokenised sukuk or gold | Potentially the cleanest; verify the underlying structure |

### Step 4: Flag operational and ethical exposure
Anonymity and money-laundering risk, exchange solvency and custody, jurisdiction, and whether customer assets are commingled. These are not all sharia issues, but they are material to a recommendation.

### Step 5: Return a range, not a word
```
verdict_range:
  - position: not_mal
    outcome: non_compliant
  - position: mal_but_not_currency
    outcome: permissible_with_conditions
  - conditions: [spot only, no leverage, no yield products, qabd at settlement]
```
Then state which position the governing authority applies, if known. If unknown: `questionable`, with the divergence spelled out.

## Output
The envelope from `references/output-contract.md`, with `dissent` filled in substantively. If the dissent field is empty, the analysis is wrong.

## Constraints & Guardrails
* DO NOT state "crypto is haram" or "crypto is halal" as a flat fact.
* DO NOT approve a yield product because the underlying token is acceptable.
* DO NOT use volatility alone as proof of gharar; explain the mechanism.
* DO NOT treat a tokenised conventional instrument as compliant because it is on-chain.
* DO NOT present one scholar's view as consensus.
* DO NOT answer a request for a religious ruling with a compliance screen; say this is informational and route to a scholar.

## Example Output
```markdown
## Asset: BTC (spot holding)
Divergence:
- Not mal → non_compliant (minority, but held by serious scholars)
- Mal but not currency → permissible with conditions (majority of permissive views)
- Currency-like → permissible with exchange-rule caveats

Applied tests: no issuer, no cash flow claim, genuine utility as a settlement network; volatility high but mechanism is price discovery, not manufactured uncertainty.
Product: spot purchase on a regulated exchange — qabd at settlement, no leverage.
Verdict range: non_compliant to permissible-with-conditions depending on the authority.
Conditions if permissive: spot only, immediate settlement, no yield, no leverage.
Escalate: true — this is a live scholarly dispute and the user is making a material allocation.

Informational analysis, not a fatwa.
```
