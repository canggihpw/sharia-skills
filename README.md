# sharia-skills

A pack of modular, markdown-based agent skills for Islamic finance, halal investing, and sharia compliance — readable by any AI coding assistant (Claude, Cursor, Codex, opencode, etc.) through the [`skills`](https://www.npmjs.com/package/skills) ecosystem.

Every skill takes a **named standard** (AAOIFI, DSN-MUI, SC Malaysia SAC, MSCI Islamic, Dow Jones Islamic Market, FTSE Shariah). A verdict without a standard is meaningless, because the thresholds and denominators genuinely differ.

## Install

```bash
# from GitHub
npx skills@latest add canggihpw/sharia-skills

# or locally, before pushing
npx skills@latest add /path/to/sharia
```

## Skills

Not sure which one to use? Start with **`sharia-ask`** — it resolves your
jurisdiction, works out what you are actually asking, and routes you to one
skill with one next action.

### `foundations/` — reasoning substrate

| Skill | Use when |
|---|---|
| `sharia-finance-principles` | Explaining why a structure is or is not permissible; riba, gharar, maysir, contract taxonomy |
| `sharia-standards-reference` | Choosing, comparing, and citing the governing standard |
| `sharia-glossary` | Disambiguating English / Arabic / Indonesian terminology |

### `investing/` — screening and analysis

| Skill | Use when |
|---|---|
| `sharia-stock-screening` | Screening a ticker: business activity, then financial ratios |
| `sharia-company-financial-review` | Extracting the screening inputs from an annual report or 10-K |
| `sharia-purification-calc` | Computing the amount to purify from dividends |
| `sharia-fund-etf-review` | Reviewing a fund, ETF, or reksadana: structure, look-through, purification |
| `sharia-sukuk-analysis` | Testing a sukuk structure: asset backing, risk transfer, guarantees |
| `sharia-portfolio-construction` | Building or rebalancing a compliant portfolio |
| `sharia-crypto-token-review` | Assessing tokens and crypto products against the actual scholarly divergence |

### `personal-finance/` — household and product decisions

| Skill | Use when |
|---|---|
| `sharia-budgeting` | Allocating household income by priority: nafkah, zakat, resilience, investment, infaq, spillover |
| `sharia-zakat-calc` | Computing zakat on cash, gold, stocks, inventory, receivables |
| `sharia-contract-review` | Auditing an akad clause by clause |
| `sharia-bank-product-review` | Verifying a specific bank product's structure and fatwa claim |

### `orchestration/` — routing and multi-subject runs

| Skill | Use when |
|---|---|
| `sharia-ask` | **Start here** when unsure: resolves jurisdiction and intent, then routes to one skill |
| `sharia-compliance-report` | Assembling an auditable report from screening evidence |
| `sharia-screening-pipeline` | Running the pack across a universe with frozen parameters |

### `context/` — staying current

| Skill | Use when |
|---|---|
| `sharia-market-context` | Before any verdict or recommendation that depends on current rules, indices, rates, or nisab — searches the web and emits a dated brief |

## Layout

```
skills/
├── foundations/
│   └── sharia-finance-principles/
│       ├── SKILL.md              # REQUIRED — the skill
│       ├── references/           # synced from shared/references
│       └── agents/
│           └── openai.yaml       # optional display metadata
├── investing/
├── personal-finance/
├── orchestration/
├── context/
shared/
└── references/                   # canonical reference files
    └── jurisdictions/            # per-country regulatory maps
scripts/
└── sync-references.sh            # copies shared/references into each skill
```

**Two-level rule:** the CLI discovers `skills/<category>/<skill-name>/SKILL.md`. Do not nest deeper — the scanner stops descending and deeper skills are silently skipped.

## Shared references

The `skills` CLI installs each skill directory individually, so a shared file at the repo root would not travel with an installed skill. `shared/references/` is the single source of truth; `scripts/sync-references.sh` copies it into every skill's `references/` directory.

```bash
npm run sync          # write the copies
npm run sync:check    # report drift, write nothing (exit 1 on drift)
```

Run `npm run sync` after editing anything in `shared/references/`, and commit the result. `sync:check` catches the two failure modes that matter: a copy edited in place (silently overwritten by the next sync) and a `shared/` change that was never propagated.

Every generated copy carries a header:

```
# GENERATED FILE — do not edit. Source: shared/references/thresholds.yaml. Run `npm run sync`.
```

Edit the file in `shared/references/`, never the copy.

| File | Contents |
|---|---|
| `context-protocol.md` | Web-search rules, freshness windows, jurisdiction resolution, degradation |
| `jurisdictions/indonesia.md` | OJK, DSN-MUI, DES/ISSI, POJK 8/2025 and 4/2026, crypto, BAZNAS nisab |
| `jurisdictions/_template.md` | Blank map for adding another country |
| `thresholds.yaml` | Machine-readable screening thresholds, bases, confidence, zakat defaults |
| `precedence.md` | Which standard governs when standards disagree |
| `prohibitions.md` | Riba, gharar, maysir, haram subject matter, operative principles |
| `contracts.md` | Contract taxonomy and the audit questions per akad |
| `glossary.md` | Terminology across English, Arabic, Indonesian |
| `output-contract.md` | Verdict vocabulary, required report fields, disclaimer |

## Validation

```bash
npm run check        # frontmatter, sections, reference links, cross-skill mentions
npm run sync:check   # generated references match shared/references
```

`check` enforces the contract between skills: every `sharia-*` name mentioned in
a skill must exist, every `references/...` link must resolve inside that skill,
every skill must carry the required sections and agent metadata, every analysis
skill must have a Step 0, and `sharia-ask` must route to all 17 other skills.

## Design rules

1. **Search before you reason.** Every skill starts with a Step 0 that names the web searches to run. Rules are amended, indices are rebalanced, nisab is reset annually, and prices move daily — a skill that answers from training data is confidently wrong. See `shared/references/context-protocol.md`.
2. **Jurisdiction first.** Screening follows the asset's listing and regulator; zakat and purification follow the investor's residence and chosen authority. When they differ, report both. Load `references/jurisdictions/<country>.md`.
3. **Standard first.** Every screening skill names the standard, edition, and data date. No silent defaults, and never mix a fatwa value with an operative rule as if they were the same.
4. **Substance over form.** A structure is judged by ownership and risk, not by its label.
5. **Contested means contested.** Where scholars disagree (crypto, tobacco, weapons, organised tawarruq, bay' al-'inah), the skill reports the range and escalates.
6. **No fatwas, no price calls.** Every skill is informational screening. A binding ruling belongs to a qualified scholar; a buy/sell call is not a compliance verdict.
7. **Evidence, not memory.** Financial inputs come from filings with a source and period, never from recall. Stale data downgrades a verdict to `questionable`.

## Adding a skill

1. Create `skills/<category>/<skill-name>/SKILL.md`.
2. Fill in `name` and `description` in the frontmatter — both required, and `description` should start with "Use when…".
3. Add `agents/openai.yaml` with `interface.display_name` and `interface.short_description`.
4. Reference shared material as `references/<file>` and run `npm run sync`.
5. Test locally with `npx skills@latest add /path/to/sharia`.

## License

MIT
