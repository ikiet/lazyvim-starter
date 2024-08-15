local cmp = require("cmp")
return {
  {
    "nvim-cmp",
    opts = {
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = function(fallback)
          if cmp.visible() then
            cmp.scroll_docs(-4)
          else
            fallback()
          end
        end,
        ["<C-f>"] = function(fallback)
          if cmp.visible() then
            cmp.scroll_docs(4)
          else
            fallback()
          end
        end,
        ["<C-e>"] = function(fallback)
          cmp.close()
          fallback()
        end,
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    },
  },
}
