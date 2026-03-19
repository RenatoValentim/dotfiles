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

## Features

- `Ctrl-a` is the leader key to keep the terminal close to the tmux setup
- `Leader+p` opens a searchable keybinding picker powered by `fzf`
- `Ctrl+Shift+t` toggles transparency and `Ctrl+Shift+y` cycles opacity levels
- tab labels prefer an explicit tab name, then the foreground process, then the current directory
- zoomed split tabs show a badge in the tab bar and in the right status area
- pane navigation, resizing, splitting, tab movement, and tab naming are tuned to match the surrounding shell and tmux workflow

## Requirements

- `wezterm`
- `bash`
- `lua` for `lua config/wezterm/tests/run.lua`
- `fzf` for the keybinding picker
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

- [ ] Increase the tab name length to max 20 characters
- [ ] Add the option to rename the tab at a specific point
- [ ] Add the option to open the tab at a specific path.
      After the new command `leader + t` to use zoxide for this.
- [x] Increase leader timeout to 3s
