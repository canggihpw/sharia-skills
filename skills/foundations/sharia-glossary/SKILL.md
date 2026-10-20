---
name: sharia-glossary
description: "Use when a request mixes English, Arabic, and Indonesian Islamic finance terms, when a term is ambiguous (riba, akad, syariah, nisab, purification, sukuk), or when a report needs consistent terminology across sources."
version: 1.1.0
author: Sharia Skills
---

# Skill: Sharia Glossary

## Purpose
Keep terminology precise so downstream reasoning is not built on a mistranslation. Defines contract names, screening terms, and commonly confused words across English, Arabic, and Indonesian, and forces ambiguity to be surfaced rather than silently resolved.

## When to Use
* User command: `/sharia-glossary`
* Autonomous trigger: the user mixes Indonesian, Arabic, and English in one request; a term is overloaded; a report needs consistent spelling; you are about to use a term whose legal scope you cannot state.
* Not for: resolving a fiqh dispute (use `sharia-finance-principles`).

## Prerequisites & Context Gathering
1. Read `references/glossary.md`.
2. Identify the source language of each term the user used.
3. Check whether the user's local authority (e.g. DSN-MUI, SAC) uses a different term for the same concept.

## Execution Workflow

### Step 0: Search only when the term is new or contested

Run a web search when the term refers to a recent product (digital gold, sharia ETF, bullion, tokenised asset) or its status is disputed. Record `as_of` and source.

- `fatwa DSN-MUI <term> <year>`
- `OJK <term> <year>`
- `"<term>" definisi syariah`

Do not search for settled classical terms; use `references/glossary.md`.

Freshness limits and jurisdiction resolution: `references/context-protocol.md`. If several current facts are needed at once, load `sharia-market-context`.

### Step 1: Look up and disambiguate
For each ambiguous term, state the senses before proceeding. Example: "riba can mean riba al-nasi'ah (deferred increase) or riba al-fadl (unequal exchange); which applies here?"

### Step 2: Normalise
Use one spelling per language:
* English prose: `sharia`, `murabaha`, `mudarabah`, `ijarah`, `sukuk`.
* Indonesian sources quoted verbatim: `syariah`, `murabahah`, `akad`, `nisab`.
* Gloss on first use: `murabaha (cost-plus sale)`.

### Step 3: Flag false friends
* *Halal* describes the object or activity, not the certificate or the institution.
* *Islamic bank* is an institution; *sharia-compliant product* is a claim about a structure.
* *Syariah* in Indonesian marketing often means "sharia-branded", which is weaker than compliant.
* *Sukuk* are not conventional bonds with an Arabic label.

### Step 4: Return a working definition
One or two sentences, operational, plus the disputed edge if any.

## Output
Inline glosses in the user's own text. A glossary section only when explicitly requested — the goal is clarity, not decoration.

## Constraints & Guardrails
* DO NOT silently translate a term whose legal scope matters.
* DO NOT use "Islamic" and "sharia-compliant" as synonyms.
* DO NOT treat definitions here as a fiqh text; they are operational.
* DO NOT invent transliterations; follow the spellings in `references/glossary.md`.
* DO NOT let a marketing term ("syariah", "halal investment") pass as a technical classification.

## Example Output
```markdown
Your request uses "akad" and "contract" interchangeably, but they are not the same thing here.

akad (aqd) = the contract itself, classified by its fiqh type (murabaha, ijarah, ...)
The compliance test depends on which akad it is, not on the existence of a signed agreement.

You also wrote "syariah deposit". That is a product label, not a structure. Which akad underlies it — wadiah or mudarabah? The answer changes whether a guaranteed profit is permissible.
```
