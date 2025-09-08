return {
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disable_mouse = false,
      ui = {
        enter = true,
        focusable = true,
        position = "50%",
        size = {
          width = "100%", -- aumenta para caber mais texto
          height = "70%",
        },
        border = {
          style = "rounded",
          text = {
            top = "Hardtime Report",
            top_align = "center",
          },
        },
      },
      callback = function(text)
        local width = math.floor(vim.o.columns * 0.5)
        local function wrap_text(str, max_width)
          local result = {}
          for line in str:gmatch("[^\n]+") do
            local current = ""
            for word, space in line:gmatch("(%S+)(%s*)") do
              if #current + #word > max_width then
                table.insert(result, current)
                current = word .. space
              else
                current = current .. word .. space
              end
            end
            table.insert(result, current)
          end
          return table.concat(result, "\n")
        end

        local wrapped_text = wrap_text(text, width)
        vim.notify(wrapped_text, vim.log.levels.WARN, { title = "Hardtime", timeout = 4999 })
      end,
    },
  },
}
