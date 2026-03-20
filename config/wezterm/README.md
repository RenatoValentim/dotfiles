# WezTerm

## Layout

- `wezterm.lua`: thin bootstrap that loads the composed configuration
- `config/init.lua`: composes the modules into the final config object
- `config/options.lua`: shared options, theme, font, and leader key
- `config/opacity.lua`: transparency toggle and opacity cycling events
- `config/tabs.lua`: dynamic tab titles, zoom badge, and right status updates
- `config/keys.lua`: keymaps and the searchable keybinding picker
- `tests/run.lua`: lightweight Lua test runner
- `tests/*_spec.lua`: focused specs for the pure WezTerm modules
- `wezterm-fzf-picker.sh`: Bash helper used by the keybinding picker
- `wezterm-tab-create.sh`: Bash helper used by the named tab prompt
- `wezterm-tab-rename.sh`: Bash helper used by the tab rename flow
- `wezterm-zoxide-picker.sh`: Bash helper used by the zoxide path picker

## Features

- `Ctrl-,` is the leader key for the shared terminal workflow
- `Leader+p` opens a searchable keybinding picker powered by `fzf`
- `Leader+c` opens an `fzf` input prompt to create a named tab
- `Leader+r` opens the inline prompt to rename the current tab and `Leader+w` opens a new tab from a `zoxide` path
- `Ctrl+Shift+t` toggles transparency
- tab labels prefer an explicit tab name, then the foreground process, then the current directory
- zoomed split tabs show a badge in the tab bar and in the right status area
- pane navigation, resizing, splitting, tab movement, and tab naming are tuned to match the surrounding shell workflow

## Requirements

- `wezterm`
- `bash`
- `lua` for `lua config/wezterm/tests/run.lua`
- `fzf` for the keybinding picker
- `zoxide` for opening tabs from indexed paths
- `JetBrains Mono Nerd Font`

## Validation

Run the shared repository checks:

```bash
./scripts/check.sh
```

This covers:

- Fish syntax checks
- Bash syntax check for `wezterm-fzf-picker.sh`
- StyLua format checks for `config/lazyvim` and `config/wezterm`
- `lua config/wezterm/tests/run.lua`

For the slower Neovim smoke test as well:

```bash
CHECK_NVIM=1 ./scripts/check.sh
```

## TODOs

- [x] Increase the tab name length to max 20 characters
- [x] Add the option to rename the tab at a specific point
- [x] Add the option to open the tab at a specific path.
      After the new command `leader + w` to use zoxide for this.
- [x] Rename the current tab from the inline prompt
- [x] Increase leader timeout to 3s
- [x] Change the leader to `ctrl+,`
