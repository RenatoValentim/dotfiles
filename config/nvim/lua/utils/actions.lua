return {
  telescope = {
    find_files = { command = ':Telescope find_files<CR>', desc = 'Find Files' },
    live_grep = { command = ':Telescope live_grep<CR>', desc = 'Live Grep' },
    find_oldfiles = { command = ':Telescope oldfiles<CR>', desc = 'Recent files' },
    find_buffers = {
      command = ':lua require("telescope.builtin").buffers()<Return>',
      desc = 'Find buffers',
    },
    find_tags = {
      command = ':lua require("telescope.builtin").help_tags()<Return>',
      desc = 'Find tags',
    },
    find_resume = {
      command = ':lua require("telescope.builtin").resume()<Return>',
      desc = 'Find resume',
    },
    find_diagnostics = {
      command = ':lua require("telescope.builtin").diagnostics()<Return>',
      desc = 'Find diagnostics',
    },
    find_keymaps = {
      command = ':lua require("telescope.builtin").keymaps()<Return>',
      desc = 'Find Keymaps',
    },
    find_projects = {
      command = ':lua require("telescope").extensions.projects.projects()<Return>',
      desc = 'Find Projects',
    },
    find_buffer_fuzzy_find = {
      command = ':lua require("telescope.builtin").current_buffer_fuzzy_find()<Return>',
      desc = 'Current buffer fuzzy find',
    },
    open_all_buffers = {
      command = ':Telescope buffers<Return>',
      desc = 'All open buffers',
    },
    docker_volumes = {
      command = ':Telescope telescope_docker docker_volumes<CR>',
      desc = '[D]ocker [V]olumes',
    },
    docker_images = {
      command = ':Telescope telescope_docker docker_images<CR>',
      desc = '[D]ocker [I]mages',
    },
    docker_processes = {
      command = ':Telescope telescope_docker docker_ps<CR>',
      desc = '[D]ocker [P]rocesses',
    },
    lsp_document_symbols = {
      command = ':Telescope lsp_document_symbols<Return>',
      desc = 'Document Symbols',
    },
    git_status = {
      command = ':Telescope git_status<Return>',
      desc = 'Open changed file in git status',
    },
    git_branch = {
      command = ':Telescope git_branches<Return>',
      desc = 'Checkout branch',
    },
    git_commit = {
      command = ':Telescope git_commits<Return>',
      desc = 'All Commits',
    },
  },
  trouble = {
    diagnostics = {
      command = '<cmd>Trouble diagnostics toggle<Return>',
      desc = 'Diagnostics (Trouble)',
    },
    diagnostics_current_file = {
      command = '<cmd>Trouble diagnostics toggle filter.buf=0<Return>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    symbols = {
      command = '<cmd>Trouble symbols toggle focus=true<Return>',
      desc = 'Symbols (Trouble)',
    },
    lsp_definitions_references = {
      command = '<cmd>Trouble lsp toggle focus=true<Return>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    loclist = {
      command = '<cmd>Trouble loclist toggle<Return>',
      desc = 'Location List (Trouble)',
    },
    qflist = {
      command = '<cmd>Trouble qflist toggle<Return>',
      desc = 'Quickfix List (Trouble)',
    },
  },
  todo_comments = {
    quickfix = {
      command = ':TodoQuickFix<Return>',
      desc = 'TODO Quickfix',
    },
    loclist = {
      command = ':TodoLocList<Return>',
      desc = 'TODO List All Todos',
    },
    telescope = {
      command = ':TodoTelescope<Return>',
      desc = 'TODO List All on Telescope',
    },
  },
}
