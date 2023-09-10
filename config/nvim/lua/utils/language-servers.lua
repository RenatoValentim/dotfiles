local M = {}

M.servers = {
  "cssls",
  "html",
  "tsserver",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "gopls",
  "dockerls",
  "cmake",
}

-- if on Linux distro
if package.config:sub(1, 1) == "/" then
  local arch = require("utils.get-os-architecture").getLinuxArchitecture()
  if arch ~= "arm64" then
    table.insert(M.servers, "lua_ls")
    table.insert(M.servers, "clangd")
  end
end

return M
