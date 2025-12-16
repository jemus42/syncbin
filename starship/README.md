# Starship Configuration

[Starship](https://starship.rs) is a minimal, blazing-fast, and infinitely customizable prompt for any shell.

## Installation

```sh
curl -sS https://starship.rs/install.sh | sh -s -- -y
```

## Configs

- `starship.toml` - Main config (symlinked to `~/.config/starship.toml` by install.sh)
- `starship-pastel-powerline.toml` - Pastel powerline preset
- `starship-pure.toml` - Pure-inspired minimal preset
- `starship-tokyo-night.toml` - Tokyo Night theme preset

## Switching Themes

### Interactive Theme Picker (Recommended)

Use the interactive theme picker to browse and try themes:

```sh
starship-theme-picker
```

This tool lets you:
- Browse all local themes and official starship presets
- Preview theme configurations with fzf
- Try themes in a temporary shell before committing
- Set a theme as default with one command

### Manual Theme Switching

Try a theme temporarily without changing your config:

```sh
STARSHIP_CONFIG=$SYNCBIN/starship/starship-tokyo-night.toml zsh
```

Replace the symlink to change default:

```sh
ln -sf $SYNCBIN/starship/starship-tokyo-night.toml ~/.config/starship.toml
```

Copy a preset to customize:

```sh
cp $SYNCBIN/starship/starship-pure.toml ~/.config/starship.toml
```
