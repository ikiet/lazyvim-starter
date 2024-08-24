return {
  {
    "echasnovski/mini.files",
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 50,
      },
      options = {
        use_as_default_explorer = false,
      },
      mappings = {
        go_in_plus = "<CR>",
        go_in = "L",
        go_out = "H",
        go_out_plus = "<BS>",
        reset = "r",
        synchronize = "<Tab>",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target_window
          local cur_target_window = require("mini.files").get_target_window()
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd("belowright " .. direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)

            require("mini.files").set_target_window(new_target_window)
            require("mini.files").go_in({ close_on_file = close_on_file })
          end
        end

        local desc = "Open in " .. direction .. " split"
        if close_on_file then
          desc = desc .. " and close"
        end
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then
          vim.fn.chdir(cur_directory)
        end
      end

      local open_sys_app = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        require("lazy.util").open(cur_entry_path, { system = true })
      end

      local copy_absolute_path = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        vim.fn.setreg("+", cur_entry_path, "c")
      end

      local copy_relative_path = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local relative_path = vim.fn.fnamemodify(cur_entry_path, ":.")
        vim.fn.setreg("+", relative_path, "c")
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id

          vim.keymap.set(
            "n",
            opts.mappings and opts.mappings.toggle_hidden or "g.",
            toggle_dotfiles,
            { buffer = buf_id, desc = "Toggle hidden files" }
          )

          vim.keymap.set(
            "n",
            opts.mappings and opts.mappings.change_cwd or "`",
            files_set_cwd,
            { buffer = buf_id, desc = "Set cwd" }
          )

          vim.keymap.set("n", "go", open_sys_app, { buffer = buf_id, desc = "Open with System Application" })

          vim.keymap.set("n", "gY", copy_absolute_path, { buffer = buf_id, desc = "Copy Absolute Path To Clipboard" })

          vim.keymap.set("n", "gy", copy_relative_path, { buffer = buf_id, desc = "Copy Relative Path To Clipboard" })

          map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "<C-X>", "horizontal", false)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "<C-V>", "vertical", false)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal_plus or "<C-x>", "horizontal", true)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "<C-v>", "vertical", true)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          LazyVim.lsp.on_rename(event.data.from, event.data.to)
        end,
      })
    end,
  },
}
