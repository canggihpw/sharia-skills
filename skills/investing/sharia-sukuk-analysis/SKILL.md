---
name: sharia-sukuk-analysis
description: "Use when the user asks whether a sukuk is sharia-compliant, needs a sukuk prospectus or term sheet reviewed, or is comparing sukuk to conventional bonds — covers ijarah, musharakah, mudarabah, wakalah, and murabaha structures, asset backing, risk transfer, guarantees, and tradability."
version: 1.0.0
author: Sharia Skills
---

# Skill: Sukuk Analysis

## Purpose
Test whether a sukuk is genuinely ownership in an asset, usufruct, or project, or a guaranteed loan wearing an Arabic label. The certificate name is irrelevant; the ownership and risk sequence decides.

## When to Use
* User command: `/sharia-sukuk-analysis`
* Autonomous trigger: reviewing a sukuk prospectus or term sheet, "is this sukuk halal", comparing a sukuk's return to a bond, or assessing an Islamic bond fund.
* Not for: equity screening (use `sharia-stock-screening`).

## Prerequisites & Context Gathering
1. Obtain the prospectus, term sheet, and structure diagram.
2. Read `references/contracts.md` for the contract type conditions.
3. Read `references/thresholds.yaml` if a ratio or tangibility threshold applies.
4. Identify the governing standard; sukuk acceptability varies materially.

## Execution Workflow

### Step 0: Refresh the deal and the rule (web search)

- `<sukuk name> prospectus` or `<sukuk name> rating report`
- `<issuer> sukuk <year>`
- `OJK sukuk syariah <year>` or `fatwa DSN-MUI SBSN`
- `<rating agency> <sukuk> <year>`

Confirm the structure has not been amended and the asset pool is current. If the prospectus is unavailable, return `insufficient_data`.

### Step 1: Classify the structure
| Type | Return source | Key test |
|---|---|---|
| Ijarah | Rent from a leased asset | Lessor owns and bears ownership risk |
| Ijarah muntahia bittamlik | Rent + later transfer | Transfer is a separate, later event |
| Musharakah | Profit share | Loss shared pro rata; no capital guarantee |
| Mudarabah | Profit share | Capital provider bears loss absent negligence |
| Wakalah | Agency fee or profit share | Agent does not guarantee the outcome |
| Murabaha | Deferred sale price | Debt-like; cannot trade at other than par |
| Salam / istisna | Prepaid or staged purchase | Delivery and specification risk |
| Hybrid | Combination | Test each leg separately |

Indonesia note: sovereign SBSN structures rest on DSN-MUI fatwas 69, 70, 71, 72 and 76/2008 (ijarah sale and lease back, asset to be leased). Retail series (SR, ST) and institutional series (PBS) use different mechanics — identify which one you are reviewing rather than assuming the fatwa covers it.

### Step 2: Asset backing and true sale
* Is there a genuine sale of identifiable assets to the issuer or SPV?
* Is it a true sale (risk and reward transfer) or financing secured on assets?
* Compute the **tangibility ratio**. Trading at market generally requires a majority of tangible assets or usufruct; below that, treat as debt and require trading at par. Verify the threshold against the governing standard.

### Step 3: Risk transfer
* Who bears loss if the asset is destroyed or the project fails?
* Is there an **unconditional guarantee** of principal or profit? That converts the structure into a loan.
* Are there purchase undertakings at face value? Permissible in some ijarah forms; they can nullify partnership risk in musharakah.
* Does the obligor promise to make up shortfalls?
* Is insurance takaful or conventional? Conventional insurance introduces riba and gharar.

### Step 4: Return mechanics
* Is the profit rate a **pricing benchmark** on a sale or lease? Acceptable.
* Is it a **guaranteed fixed return on invested capital**? Riba.
* Are the periodic distributions rent, profit share, or a fixed coupon in substance?
* Is there a **capital guarantee at maturity**? Acceptable only where the structure permits it, not in partnership structures.

### Step 5: Penalties and covenants
* Late-payment penalties should go to charity, not to the issuer's income.
* Acceleration clauses must not create an interest-like charge.
* Benchmark-linked pricing adjustments may be acceptable; damages for delay may not.

### Step 6: Documentation consistency
Read the term sheet against the structure diagram. The common failure is a diagram showing ijarah while the documents impose lessee-side ownership risk, conventional insurance, and a full guarantee.

### Step 7: Verdict
| Condition | Verdict |
|---|---|
| Genuine asset ownership, risk transfer, no unconditional guarantee | `compliant` |
| Guaranteed capital or fixed return on a partnership structure | `non_compliant` |
| Sound structure with a contested feature (face-value purchase undertaking, organised tawarruq) | `questionable` |
| Prospectus or asset details unavailable | `insufficient_data` |

## Output
The envelope from `references/output-contract.md`, plus a text structure map (issuer → SPV → assets → obligor), the tangibility ratio, and a guarantee inventory.

## Constraints & Guardrails
* DO NOT accept the label in place of the structure.
* DO NOT overlook the difference between asset-based and asset-backed. Most sukuk are asset-based, with recourse to the obligor rather than the assets; disclose that.
* DO NOT approve a guaranteed return on a musharakah or mudarabah.
* DO NOT ignore conventional insurance embedded in the structure.
* DO NOT assume a green or sustainability label implies a compliant use of proceeds; screen the projects.
* DO NOT omit the default and restructuring behaviour — asset-based sukuk often behave like unsecured debt.

## Example Output
```markdown
## Sukuk: XYZ Ijarah Trust 2029
Structure: issuer → SPV → owns leasehold interest in a port facility → leases to obligor → distributes rent.
Tangibility: 84% of assets are tangible → tradable at market under the governing standard.
Guarantees: no unconditional principal guarantee; purchase undertaking at expiry at a pre-agreed formula. Flagged: formula approximates face value.
Insurance: takaful. Penalties: to charity.
Verdict: questionable — the purchase undertaking may convert partnership risk into a guaranteed return; a scholar must opine on the formula.
Informational screening, not a fatwa.
```
