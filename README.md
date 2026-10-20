# sharia-skills

A pack of modular, markdown-based agent skills for Islamic finance, halal investing, and sharia compliance — readable by any AI coding assistant (Claude, Cursor, Codex, opencode, etc.) through the [`skills`](https://www.npmjs.com/package/skills) ecosystem.

Every skill takes a **named standard** (AAOIFI, DSN-MUI, SC Malaysia SAC, MSCI Islamic, Dow Jones Islamic Market, FTSE Shariah). A verdict without a standard is meaningless, because the thresholds and denominators genuinely differ.

## Install

```bash
# from GitHub
npx skills@latest add <owner>/sharia-skills

# or locally, before pushing
npx skills@latest add /path/to/sharia
```

## Skills

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
| `sharia-zakat-calc` | Computing zakat on cash, gold, stocks, inventory, receivables |
| `sharia-contract-review` | Auditing an akad clause by clause |
| `sharia-bank-product-review` | Verifying a specific bank product's structure and fatwa claim |

### `orchestration/` — multi-subject runs

| Skill | Use when |
|---|---|
| `sharia-compliance-report` | Assembling an auditable report from screening evidence |
| `sharia-screening-pipeline` | Running the pack across a universe with frozen parameters |

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
shared/
└── references/                   # canonical reference files
scripts/
└── sync-references.sh            # copies shared/references into each skill
```

**Two-level rule:** the CLI discovers `skills/<category>/<skill-name>/SKILL.md`. Do not nest deeper — the scanner stops descending and deeper skills are silently skipped.

## Shared references

The `skills` CLI installs each skill directory individually, so a shared file at the repo root would not travel with an installed skill. `shared/references/` is the single source of truth; `scripts/sync-references.sh` copies it into every skill's `references/` directory.

```bash
npm run sync
```

Run it after editing anything in `shared/references/`, and commit the result.

| File | Contents |
|---|---|
| `thresholds.yaml` | Machine-readable screening thresholds, bases, confidence, zakat defaults |
| `precedence.md` | Which standard governs when standards disagree |
| `prohibitions.md` | Riba, gharar, maysir, haram subject matter, operative principles |
| `contracts.md` | Contract taxonomy and the audit questions per akad |
| `glossary.md` | Terminology across English, Arabic, Indonesian |
| `output-contract.md` | Verdict vocabulary, required report fields, disclaimer |

## Design rules

1. **Standard first.** Every screening skill names the standard, edition, and data date. No silent defaults.
2. **Substance over form.** A structure is judged by ownership and risk, not by its label.
3. **Contested means contested.** Where scholars disagree (crypto, tobacco, weapons, organised tawarruq, bay' al-'inah), the skill reports the range and escalates.
4. **No fatwas.** Every skill is informational screening. A binding ruling belongs to a qualified scholar or an institution's sharia supervisory board.
5. **Evidence, not memory.** Financial inputs come from filings with a source and period, never from recall.

## Adding a skill

1. Create `skills/<category>/<skill-name>/SKILL.md`.
2. Fill in `name` and `description` in the frontmatter — both required, and `description` should start with "Use when…".
3. Add `agents/openai.yaml` with `interface.display_name` and `interface.short_description`.
4. Reference shared material as `references/<file>` and run `npm run sync`.
5. Test locally with `npx skills@latest add /path/to/sharia`.

## License

MIT
