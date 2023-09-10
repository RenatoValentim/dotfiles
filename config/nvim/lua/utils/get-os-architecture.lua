local M = {}

function M.getLinuxArchitecture()
  local f = assert(io.popen("uname -m", "r"))
  local arch = f:read "*a"
  f:close()
  return arch
end

return M
