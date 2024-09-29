return {
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>gs",
        function()
          vim.cmd("DiffviewOpen ")
        end,
        desc = "Open Diffview",
      },
      {
        "<leader>gT",
        function()
          vim.cmd("DiffviewFileHistory")
        end,
        desc = "Open DiffviewFileHistory",
      },
      {
        "<leader>gt",
        function()
          vim.cmd("DiffviewFileHistory %")
        end,
        desc = "Open DiffviewFileHistory (Current File)",
      },
    },
    opts = {
      enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
      file_panel = {
        listing_style = "list", -- One of 'list' or 'tree'
        win_config = { -- See |diffview-config-win_config|
          position = "left",
          width = 30,
          win_opts = {},
        },
      },
    },
  },
}
