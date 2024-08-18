return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_a = {}
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({ length = 0 }),
      }
      opts.sections.lualine_y = {
        { "location" },
      }
      opts.sections.lualine_z = {}
    end,
  },
}
