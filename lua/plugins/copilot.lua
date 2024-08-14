return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false },
      panel = {
        enabled = true,
        layout = {
          position = "right",
          ratio = 0.35,
        },
      },
      filetypes = {
        js = false,
        ts = false,
        javascript = false,
        typescript = false,
        javascriptreact = false,
        typescriptreact = false,
      },
    },
  },
}
