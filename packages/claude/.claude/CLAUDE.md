# Global Instructions

## Code Guidelines

- Source files always end with a newline
- Verify assumptions via documentation or temporary test scripts (remove after use)

## Language Tooling

- **R**: use `air format` to format files per project air.toml
- **Python**: use `uv` for dependency management
- **LaTeX**: use `latexmk -pdf -halt-on-error` (handles multi-pass compilation)

## Knowledge Base

A personal Obsidian vault lives at `~/vault` (git-synced across machines). Use it as a reference for my work, projects, and preferences. Key areas:

- `research/` — papers, methods, domain knowledge
- `projects/` — project notes, decisions, context
- `ingress/` — recent captures, unsorted notes

When relevant context might exist in the vault, check it before asking me. To search: `rg --type md <pattern> ~/vault`
