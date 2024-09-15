return {
  {
    "NeogitOrg/neogit",
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
    },
    keys = {
      {
        "<leader>ng",
        function()
          local neogit = require("neogit")
          local root = LazyVim.root()
          neogit.open({ cwd = root })
        end,
        desc = "Neogit (root)",
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

