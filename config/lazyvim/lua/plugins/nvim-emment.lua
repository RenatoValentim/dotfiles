return {
  "olrtg/nvim-emmet",
  config = function()
    local map = LazyVim.safe_keymap_set

    map({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
  end,
}
