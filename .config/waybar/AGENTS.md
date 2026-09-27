# AGENTS.md — Waybar Configuration

> Guidelines for AI coding agents operating in this repository.

## Overview

This is a **Waybar configuration directory** for a Wayland desktop using the
**Hyprland** compositor. It contains declarative configuration files — there is
no compiled code, no build system, and no test framework.

Key files:

| File | Format | Purpose |
|---|---|---|
| `config.jsonc` | JSONC | Main bar layout, modules, and behavior |
| `style.css` | CSS (GTK3) | Visual styling for the bar and all modules |
| `.catppuccin.yaml` | YAML | Catppuccin color theme manifest (unused/beta) |
| `.editoconfig` | EditorConfig | Formatting rules (NOTE: filename is misspelled) |

## Build / Lint / Test Commands

There is no build system, linter, or test suite. To validate changes:

```bash
# Validate JSONC syntax (strip comments, then check JSON)
sed 's|//.*$||' config.jsonc | python3 -m json.tool > /dev/null

# Restart Waybar to apply changes
killall waybar && waybar &

# Check Waybar logs for module errors
journalctl --user -u waybar -f
```

There is no single-test command. Manual verification by restarting Waybar and
inspecting the bar visually is the only testing method.

## Desktop Environment Context

Agents must understand the runtime environment when editing configs:

- **Compositor:** Hyprland (modules use `hyprland/workspaces`, `hyprland/window`)
- **Lock screen:** hyprlock
- **Audio:** PulseAudio (`pactl`, `pavucontrol`)
- **Power:** systemd (`systemctl reboot`, `systemctl poweroff`)
- **Hardware sensors:** lm-sensors (`sensors` + `awk`)
- **Backlight device:** `intel_backlight`
- **Timezone:** `Europe/Paris`
- **Language:** Comments are written in **French**

## Code Style Guidelines

### General Formatting

- **Indentation:** 2 spaces for JSONC and CSS. Never use tabs.
- **Encoding:** UTF-8
- **Line endings:** LF (Unix)
- **Trailing whitespace:** Trim (except in Markdown)
- **Final newline:** Always insert

These rules are declared in `.editoconfig` (note: the filename is misspelled
and won't be detected by editors — it should be `.editorconfig`).

### JSONC (`config.jsonc`)

- Use `//` comments. Write comments in **French**.
- All keys and string values use **double quotes**.
- Trailing spaces inside format strings (e.g., `"{usage}% "`) are
  **intentional** — they add visual padding in the bar. Do not remove them.
- Module format strings use **Pango markup** for inline icon coloring:
  ```jsonc
  "format": "<span color='#00FF7F'></span> {volume}%"
  ```
- Icons are **Nerd Font glyphs** (Unicode private-use-area codepoints).
  Always use the glyph character directly, never Unicode escape sequences.
- The bar has three zones: `modules-left`, `modules-center`, `modules-right`.

### Module Configuration Pattern

Every module should follow this consistent structure:

```jsonc
"module-name": {
  "format": "<span color='#HEX'>ICON</span> {value}",
  "tooltip": true,
  "tooltip-format": "Descriptive tooltip text",
  "on-click": "command-to-run",
  "interval": 5
}
```

Optional keys used as needed: `format-icons`, `format-alt`, `states`,
`on-click-right`, `max-length`, `min-length`.

### Color Palette

Colors are applied inline via Pango `<span color='#HEX'>` in JSONC format
strings, not via CSS variables. Use the established palette consistently:

| Color | Hex | Used for |
|---|---|---|
| Cyan | `#00FFFF` | Lock, WiFi, phone audio |
| Gold | `#FFD700` | Reboot, bright backlight |
| Red | `#FF4040` | Power off, disconnected, muted |
| Green | `#00FF7F` | Audio volume, wired network |
| Spring Green | `#28CD41` | Battery |
| Chartreuse | `#7FFF00` | Battery alt |
| Purple | `#BF00FF` | Clock |
| Blue Violet | `#8A2BE2` | Memory, headphones |
| Orange | `#FFA500` | Temperature, CPU, car audio |
| Deep Sky Blue | `#00BFFF` | Bluetooth, download bandwidth |
| Deep Pink | `#FF1493` | Upload bandwidth |

Do **not** introduce new colors without a clear purpose. Prefer reusing
existing palette entries.

### CSS (`style.css`)

- Write comments in **French** (e.g., `/* Paramètres globaux */`).
- Use `rgba()` for semi-transparent backgrounds.
- Module selectors follow Waybar conventions: `#module-name`, `#module-name.class`.
- Custom modules use `#custom-modulename` (note the hyphen before the name).
- Border radius convention for grouped modules:
  - Left edge: `border-radius: 10px 0 0 10px;`
  - Right edge: `border-radius: 0 10px 10px 0;`
  - Middle: `border-radius: 0;`
- Hover effects use `/* Survol de la souris */` comment pattern.
- Preserve commented-out rules — they serve as reference alternatives.

### Shell Commands (inline in JSONC)

- Commands appear in `"exec"`, `"on-click"`, and `"on-click-right"` keys.
- Keep commands short and single-line. For complex logic, create a script
  in `~/.local/bin/` and reference it by path.
- Pipe chains are acceptable for simple transformations:
  ```jsonc
  "exec": "sensors | awk '/^Package id 0:/ {print int($4)}'"
  ```
- Always use absolute paths or commands expected to be in `$PATH`.

## Error Handling

Waybar configs have limited error handling. Use these patterns:

- Define `"states"` with `"warning"` and `"critical"` thresholds for numeric
  modules (battery, temperature). These map to CSS classes for visual alerts.
- Provide format variants for different states: `format-wifi`,
  `format-disconnected`, `format-muted`, etc.
- The CSS should define styles for `.warning` and `.critical` state classes.

## Known Issues

Agents should be aware of these existing issues:

1. **`.editoconfig`** — Filename is misspelled; should be `.editorconfig`.
   Editors will not detect it. Consider renaming.
2. **`style.css:67`** — Typo: `#custpm-temperature.critical` should be
   `#custom-temperature.critical`. The critical-temperature style never applies.
3. **`config.jsonc:80`** — Uses a tab instead of 2-space indent (inconsistency).
4. **`.catppuccin.yaml`** — References a `themes/` directory that does not
   exist. The theme is not actively integrated into `style.css`.

## Naming Conventions

- Custom module names: `custom-<descriptive-name>` (lowercase, hyphenated).
- CSS class names follow Waybar's auto-generated pattern from module names.
- No file-naming convention beyond Waybar's expected filenames.

## Dependencies

Changes may require these tools to be installed on the system:

- `waybar`, `hyprland`, `hyprlock`
- `pactl`, `pavucontrol` (PulseAudio)
- `lm-sensors` (for `sensors` command)
- `systemd` (for `systemctl`)
- A **Nerd Font** (for icon glyphs to render correctly)
