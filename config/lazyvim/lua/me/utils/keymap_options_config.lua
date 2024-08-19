local M = {}

function M.set_keymap_options(noremap, silent, desc)
  noremap = noremap == nil and true or noremap
  silent = silent == nil and true or silent
  desc = desc or 'No description provided'

  return { noremap = noremap, silent = silent, desc = desc }
end

return M
