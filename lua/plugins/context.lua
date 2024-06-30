return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    keys = {
      {
        "gk",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Jumping to context (upwards)",
      },
    },
  },
}
