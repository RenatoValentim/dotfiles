local M = {}

M.servers = {
  'cssls',
  'html',
  'tsserver',
  'pyright',
  'bashls',
  'jsonls',
  'yamlls',
  'gopls',
  'dockerls',
  'cmake',
  -- "sqls",
  'eslint',
  'prismals',
}

-- if on Linux distro
if package.config:sub(1, 1) == '/' then
  local get_arch = require 'utils.get-os-architecture'
  local arch = get_arch.getLinuxArchitecture()
  if arch ~= get_arch.android_arch then
    table.insert(M.servers, 'lua_ls')
    table.insert(M.servers, 'clangd')
  end
end

return M
