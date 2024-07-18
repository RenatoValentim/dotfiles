local M = {
  "ravenxrz/DAPInstall.nvim",
  commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de",
}

function M.config()
  local dap_inatall = require("dap-install")
  dap_inatall.setup {}
  dap_inatall.config("python", {})
  dap_inatall.config("go_delve", {})
end

return M
