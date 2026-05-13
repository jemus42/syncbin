# R Project Conventions

Copy relevant sections into your project's CLAUDE.md.

## R Conventions

- Prefer cli package over cat() for user-facing output
- No return() at end of functions — only for early returns
- Avoid print() where evaluating the expression suffices
- Prefer data.table in package code; tidyverse ok in interactive/quarto
- ggplot2 default: theme_minimal(base_size = 14)
- Use devtools for test/check/document workflow
- Use testthat 3e for tests
- In quarto, keep code chunk comments brief — write prose in document body
- Projects typically use renv (snapshot-based) or rv (declarative TOML-based, https://github.com/A2-ai/rv) for dependency management
