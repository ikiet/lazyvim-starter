return {
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "ibhagwan/fzf-lua", -- optional
    },
    opts = {
      kind = "vsplit",
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { "󰄾", "󰄼" },
        section = { "", "" },
      },
      commit_editor = {
        kind = "floating",
      },
      commit_select_view = {
        kind = "floating",
      },
      commit_view = {
        kind = "floating",
      },
      popup = {
        kind = "floating",
      },
    },
    keys = {
      {
        "<leader>ng",
        function()
          local neogit = require("neogit")
          local cwd = vim.fn.expand("%:p:h")
          neogit.open({ cwd = cwd })
        end,
        desc = "Neogit (Current dir)",
      },
      {
        "<leader>nG",
        function()
          local neogit = require("neogit")
          neogit.open({ cwd = vim.uv.cwd() })
        end,
        desc = "Neogit (cwd)",
      },
    },
  },
}
