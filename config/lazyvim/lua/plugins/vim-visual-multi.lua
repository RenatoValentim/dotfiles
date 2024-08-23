return {
  'mg979/vim-visual-multi',
  branch = 'master',
  config = function()
    local map = LazyVim.safe_keymap_set

    map('n', '<A-Down>', '<Plug>(VM-Add-Cursor-Down)', { desc = 'Add Cursor Down' })
    map('n', '<A-Up>', '<Plug>(VM-Add-Cursor-Up)', { desc = 'Add Cursor Up' })
  end,
}
