local get_arch = require("utils.get-os-architecture")
local arch = get_arch.getLinuxArchitecture()

local M = {}

M.dashboard = {
  find_files = (arch == get_arch.android_arch) and " " or "󰈞 ",
  new_files = (arch == get_arch.android_arch) and " " or " ",
  find_project = (arch == get_arch.android_arch) and " " or " ",
  recent_files = (arch == get_arch.android_arch) and " " or " ",
  find_text = (arch == get_arch.android_arch) and " " or "󰊄 ",
  config = (arch == get_arch.android_arch) and " " or " ",
  quit = (arch == get_arch.android_arch) and " " or "󰅖 ",
}

M.cmp = {
  Text = (arch == get_arch.android_arch) and "" or "",
  Method = (arch == get_arch.android_arch) and "" or "",
  Function = (arch == get_arch.android_arch) and "" or "",
  Constructor = (arch == get_arch.android_arch) and "" or "",
  Field = (arch == get_arch.android_arch) and "" or "",
  Variable = (arch == get_arch.android_arch) and "" or "",
  Class = (arch == get_arch.android_arch) and "" or "",
  Interface = (arch == get_arch.android_arch) and "" or "",
  Module = (arch == get_arch.android_arch) and "" or "",
  Property = (arch == get_arch.android_arch) and "" or "",
  Unit = (arch == get_arch.android_arch) and "" or "",
  Value = (arch == get_arch.android_arch) and "" or "",
  Enum = (arch == get_arch.android_arch) and "" or "",
  Keyword = (arch == get_arch.android_arch) and "" or "",
  Snippet = (arch == get_arch.android_arch) and "" or "",
  Color = (arch == get_arch.android_arch) and "" or "",
  File = (arch == get_arch.android_arch) and "" or "",
  Reference = (arch == get_arch.android_arch) and "" or "",
  Folder = (arch == get_arch.android_arch) and "" or "󰉋",
  EnumMember = (arch == get_arch.android_arch) and "" or "",
  Constant = (arch == get_arch.android_arch) and "" or "",
  Struct = (arch == get_arch.android_arch) and "" or "",
  Event = (arch == get_arch.android_arch) and "" or "",
  Operator = (arch == get_arch.android_arch) and "" or "",
  TypeParameter = (arch == get_arch.android_arch) and "" or "",
}

M.lsp = {
  error = "",
  warn = "",
  hint = "",
  info = "",
}

M.plugins = {
  dapui = {
    expanded = "",
    collapsed = "",
    circular = "",
    pause = "",
    play = "",
    run_last = "",
    step_back = "",
    step_out = "",
    step_into = "",
    step_over = "",
    terminate = "",
    breakpoint = "",
  },
  gitsigns = {
    add = "▎",
    change = "▎",
    delete = (arg == get_arch.android_arch) and "󰐊" or "",
    topdelete = (arg == get_arch.android_arch) and "󰐊" or "",
    changedelete = "▎",
  },
  indent_blankline = {
    char = "▏",
  },
  lualine = {
    error = " ",
    warn = " ",
    added = " ",
    modified = " ",
    removed = " ",
    separators_left = "",
    separators_right = "",
    git_branch = "",
    tab = (arch == get_arch.android_arch) and "" or "󰌒 ",
  },
  mason = {
    installed = "◍",
    pending = "◍",
    uninstalled = "◍",
  },
  noice = {
    cmdline = "",
    search_down = " ",
    search_up = " ",
    filter = "",
    lua = "",
    help = "",
  },
  nvim_dev_icon = {
    zsh    = "",
    docker = "",
    env    = "",
    go     = (arch == get_arch.android_arch) and "ﳑ" or "",
  },
  nvim_tree = {
    corner = "└",
    edge = "│",
    item = "│",
    none = " ",
    padding = " ",
    symlink_arrow = " ➛ ",
    default = "",
    symlink = "",
    arrow_open = "",
    arrow_closed = "",
    folder_default = "",
    open = "",
    empty = "",
    empty_open = "",
    folder_symlink = "",
    symlink_open = "",
    git_unstaged = "",
    git_staged = "S",
    git_unmerged = (arch == get_arch.android_arch) and "" or "",
    git_renamed = (arch == get_arch.android_arch) and "" or "",
    git_untracked = "U",
    git_deleted = (arch == get_arch.android_arch) and "" or "",
    git_ignored = "◌",
    hint = (arch == get_arch.android_arch) and "" or "",
    info = "",
    warning = "",
    error = "",
  },
  telescope = {
    prompt_prefix = " ",
    selection_caret = " ",
  },
  todo_comments = {
    fix = (arch == get_arch.android_arch) and " " or " ",
    todo = (arch == get_arch.android_arch) and " " or " ",
    hack = (arch == get_arch.android_arch) and " " or " ",
    warn = (arch == get_arch.android_arch) and " " or "",
    perf = (arch == get_arch.android_arch) and " " or "󰅒 ",
    note = (arch == get_arch.android_arch) and " " or " ",
  },
  lspsaga = {
    breadcrumbs_separator = " » ",
  }
}

return M
