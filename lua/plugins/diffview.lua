local open_popup = function()
  local view = require("diffview.lib").get_current_view()
  if view == nil then
    return
  end
  local git_path = view.adapter.ctx.toplevel
  if git_path == nil then
    return
  end
  local neogit = require("neogit")
  -- TODO: currently unable to pass cwd to the popup
  -- neogit.open({ "commit", cwd = git_path })
  neogit.open({ cwd = git_path, kind = "floating" })
end
return {
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>gd",
        function()
          vim.cmd("DiffviewOpen ")
        end,
        desc = "Open Diffview",
      },
      {
        "<leader>gT",
        function()
          vim.cmd("DiffviewFileHistory")
        end,
        desc = "Open DiffviewFileHistory",
      },
      {
        "<leader>gt",
        function()
          vim.cmd("DiffviewFileHistory %")
        end,
        desc = "Open DiffviewFileHistory (Current File)",
      },
    },
    opts = {
      enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
      file_panel = {
        listing_style = "list", -- One of 'list' or 'tree'
        win_config = { -- See |diffview-config-win_config|
          position = "left",
          width = 30,
          win_opts = {},
        },
      },
      keymaps = {
        view = {
          {
            "n",
            "<leader>cc",
            open_popup,
            { desc = "Commit staged changes (Current dir)" },
          },
        },
        file_panel = {
          {
            "n",
            "<leader>cc",
            open_popup,
            { desc = "Commit staged changes (Current dir)" },
          },
        },
      },
    },
  },
}
