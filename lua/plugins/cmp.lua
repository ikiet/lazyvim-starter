local cmp = require("cmp")
local closeThenFallback = function(fallback)
  cmp.close()
  fallback()
end

return {
  {
    "nvim-cmp",
    opts = {
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = closeThenFallback,
        ["<C-f>"] = closeThenFallback,
        ["<C-e>"] = closeThenFallback,
        ["<C-a>"] = closeThenFallback,
        ["<C-u>"] = function(fallback)
          if cmp.visible() then
            cmp.scroll_docs(-4)
          else
            fallback()
          end
        end,
        ["<C-d>"] = function(fallback)
          if cmp.visible() then
            cmp.scroll_docs(4)
          else
            fallback()
          end
        end,
      }),
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      preselect = cmp.PreselectMode.None,
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    },
  },
}
