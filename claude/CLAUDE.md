# Global Instructions

## Code Guidelines

- Source files always end with a newline
- Verify assumptions via documentation or temporary test scripts (remove after use)

## Language Tooling

- **R**: use `air format` to format files per project air.toml
- **Python**: use `uv` for dependency management
- **LaTeX**: use `latexmk -pdf -halt-on-error` (handles multi-pass compilation)
