vim.cmd('autocmd!')
local vim_opt = vim.opt

local default_shell = os.getenv('SHELL')

if default_shell and default_shell:match('zsh') then
  vim.o.shell = 'zsh'
else
  vim.o.shell = 'bash'
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.scriptencoding = 'utf-8'
vim_opt.encoding = 'utf-8'
vim_opt.fileencoding = 'utf-8'

vim_opt.number = true
vim_opt.relativenumber = true

vim_opt.title = true
vim_opt.autoindent = true
vim_opt.smartindent = true
vim_opt.hlsearch = true
vim_opt.backup = false
vim_opt.showcmd = true
vim_opt.cmdheight = 1
vim_opt.laststatus = 3
vim_opt.expandtab = true
vim_opt.scrolloff = 10
vim_opt.sidescrolloff = 10
vim_opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim_opt.inccommand = 'split'
vim_opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim_opt.smarttab = true
vim_opt.breakindent = true
vim_opt.shiftwidth = 2
vim_opt.tabstop = 2
vim_opt.softtabstop = 2
vim_opt.wrap = false -- No Wrap lines
vim_opt.backspace = { 'start', 'eol', 'indent' }
vim_opt.listchars:append('eol:↴')
vim_opt.list = true
vim_opt.path:append({ '**' }) -- Finding files - Search down into subfolders
vim_opt.wildignore:append({ '*/node_modules/*' })
vim_opt.clipboard = 'unnamedplus'
vim_opt.hidden = true
vim_opt.incsearch = true
vim_opt.updatetime = 300
vim_opt.signcolumn = 'yes'
vim_opt.swapfile = false
vim_opt.cursorline = true
vim_opt.completeopt = { 'menuone', 'noselect' }
vim_opt.conceallevel = 0
vim_opt.mouse = 'a'
vim_opt.pumheight = 10
vim_opt.showtabline = 0
vim_opt.smartcase = true
vim_opt.splitbelow = false
vim_opt.splitright = false
vim_opt.termguicolors = true
vim_opt.timeout = true
vim_opt.timeoutlen = 300
vim_opt.undofile = true
vim_opt.writebackup = false
vim_opt.ruler = false
vim_opt.numberwidth = 4
vim_opt.guifont = 'monospace:h17'
vim_opt.fillchars.eob = ' '
vim_opt.shortmess:append('c')
vim_opt.whichwrap:append('<,>,[,],h,l')
vim_opt.iskeyword:append('-')
vim_opt.linebreak = true

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste',
})

vim_opt.formatoptions:remove({ 'c', 'r', 'o' })
