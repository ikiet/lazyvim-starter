return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {
          cmd_env = { RUST_LOG = "error" },
          init_options = {
            -- Custom config. Used together with a config file found in the workspace or its parents,
            -- taking precedence for settings declared in both.
            -- Equvialent to the typos `--config` cli argument.
            config = "~/.config/typos.toml",
            -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
            -- Defaults to error.
            diagnosticSeverity = "Warning",
          },
        },
      },
    },
  },
}
