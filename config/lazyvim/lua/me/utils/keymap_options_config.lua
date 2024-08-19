local M = {}

---@param args table {noremap: boolean, silent: boolean, desc: string}
function M.set_keymap_options(args)
  local noremap = args.noremap or true
  local silent = args.silent or true
  local desc = args.desc or 'No description provided'

  return { noremap = noremap, silent = silent, desc = desc }
end

return M
