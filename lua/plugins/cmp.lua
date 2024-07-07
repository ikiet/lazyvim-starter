local cmp = require("cmp")
return {
  {
    "nvim-cmp",
    opts = {
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = LazyVim.cmp.confirm({ select = false }),
      }),
      completion = {
        completeopt = "noselect",
      },
      preselect = cmp.PreselectMode.None,
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    },
  },
}
