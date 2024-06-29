local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.yarn/*")

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>ff",
        function() require("telescope.builtin").find_files() end,
        desc = "Find File",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ no_ignore = true })
        end,
        desc = "Find File (No Ignore)",
      },
    },
    -- change some options
    opts = {
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!**/.yarn/*" },
        },
        oldfiles = {
          cwd_only = true,
        },
      },
      defaults = {
        mappings = {
          i = {
            ["<M-n>"] = require("telescope.actions").cycle_history_next,
            ["<M-p>"] = require("telescope.actions").cycle_history_prev,
          },
        },
        vimgrep_arguments = vimgrep_arguments,
        path_display = {
          filename_first = {
            reverse_directories = false,
          },
        },
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
}
