local actions = require('utils.actions')

return {
  'krisajenkins/telescope-docker.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('telescope').load_extension('telescope_docker')
    require('telescope_docker').setup({})
  end,

  -- Example keybindings. Adjust these to suit your preferences or remove
  --   them entirely:
  keys = {
    {
      '<Leader>dv',
      actions.telescope.docker_volumes.command,
      actions.telescope.docker_volumes.desc,
    },
    {
      '<Leader>di',
      actions.telescope.docker_images.command,
      actions.telescope.docker_images.desc,
    },
    {
      '<Leader>dp',
      actions.telescope.docker_processes.command,
      actions.telescope.docker_processes.desc,
    },
  },
}
