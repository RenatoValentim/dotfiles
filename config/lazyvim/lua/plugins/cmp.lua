return {
  'nvim-cmp',
  dependencies = {
    { 'hrsh7th/cmp-cmdline' },
  },
  opts = function(_, opts)
    table.insert(opts.sources, 1, {
      name = 'cmp_tabnine',
      group_index = 1,
      priority = 0,
    })

    opts.formatting.format = LazyVim.inject.args(opts.formatting.format, function(entry, item)
      if entry.source.name == 'cmp_tabnine' then
        item.menu = ''
      end
    end)
  end,
  event = {
    'InsertEnter',
    'CmdlineEnter',
  },
}
