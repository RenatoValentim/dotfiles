local M = {}

M.terminal = "alacritty"
M.editor = os.getenv("EDITOR") or "nvim"
M.editor_cmd = M.terminal .. " -e " .. "nvim"

return M
