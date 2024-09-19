return {
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>gd",
        function()
          vim.cmd("DiffviewOpen ")
        end,
        desc = "Open Diffview",
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
      keymaps = {
        view = {},
        file_panel = {
          {
            "n",
            "cc",
            "<Cmd>Neogit commit<CR>",
            { desc = "Commit staged changes" },
          },
          {
            "n",
            "ca",
            "<Cmd>Git commit --amend <bar> wincmd J<CR>",
            { desc = "Amend the last commit" },
          },
          {
            "n",
            "c<space>",
            ":Git commit ",
            { desc = 'Populate command line with ":Git commit "' },
          },
        },
      },
    },
  },
}
