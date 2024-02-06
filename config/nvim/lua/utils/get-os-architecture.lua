local M = {}

M.android_arch = "aarch64"

function M.getLinuxArchitecture()
  local f = assert(io.popen("uname -m", "r"))
  local arch = f:read("*a"):gsub("[\r\n]+", "")
  f:close()
  return arch
end

return M
