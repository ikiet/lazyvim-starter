return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find File",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ no_ignore = true })
        end,
        desc = "Find File (No Ignore)",
      },
      {
        "<leader>fp",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"),
            select_buffer = true,
            previewer = false,
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            initial_mode = "normal",
          })
        end,
        desc = "File Browser",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      local configs = require("telescope.config")
      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(configs.values.vimgrep_arguments) }

      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--hidden")
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.yarn/*")

      opts.defaults = {
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
      }
      opts.pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!**/.yarn/*" },
        },
        oldfiles = {
          cwd_only = true,
        },
      }
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = false,
          mappings = {
            -- your custom insert mode mappings
            ["n"] = {
              -- your custom normal mode mappings
              ["a"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["c"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["o"] = fb_actions.open,
              ["/"] = fb_actions.goto_cwd,
              ["~"] = fb_actions.goto_home_dir,
            },
          },
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
}
