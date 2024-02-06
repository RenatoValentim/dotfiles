local M = {}

M.android_arch = "aarch64"

function M.getLinuxArchitecture()
  local f = assert(io.popen("uname -m", "r"))
  local arch = f:read "*a"
  f:close()
  ARCH = arch
  return arch
end

return M
