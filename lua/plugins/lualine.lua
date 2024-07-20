return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = LazyVim.config.icons
      opts.inactive_winbar = {
        lualine_a = {
          {
            "filename",
            path = 0,
          },
        },
      }
      opts.winbar = {
        lualine_b = {
          {
            "diagnostics",
            separator = "",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
            colored = true, -- Displays diagnostics status in color if set to true.
            padding = { left = 1, right = 1 },
          },
          {
            "filename",
            separator = "",
            path = 1,
            padding = 0,
          },
        },
      }
    end,
  },
}
