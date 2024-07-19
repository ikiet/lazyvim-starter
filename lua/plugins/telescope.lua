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
        "<leader>e",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"),
            select_buffer = true,
            previewer = true,
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
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<C-l>"] = actions.select_default,
            ["<C-s>"] = actions.cycle_previewers_next,
            ["<C-a>"] = actions.cycle_previewers_prev,
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
          hide_parent_dir = true,
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            -- your custom insert mode mappings
            ["n"] = {
              -- your custom normal mode mappings
              ["h"] = fb_actions.goto_parent_dir,
              ["a"] = fb_actions.create,
              ["c"] = fb_actions.copy,
              ["l"] = actions.select_default,
              ["m"] = fb_actions.move,
              ["o"] = fb_actions.open,
              ["y"] = function()
                local entry = require("telescope.actions.state").get_selected_entry()
                local cb_opts = vim.opt.clipboard:get()
                if vim.tbl_contains(cb_opts, "unnamed") then
                  vim.fn.setreg("*", entry.path)
                end
                if vim.tbl_contains(cb_opts, "unnamedplus") then
                  vim.fn.setreg("+", entry.path)
                end
                vim.fn.setreg("", entry.path)
              end,
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
