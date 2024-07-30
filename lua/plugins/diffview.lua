vim.keymap.set({ "n", "c" }, "<leader>0", "<cmd>DiffviewToggle<cr>")
vim.api.nvim_create_user_command("DiffviewToggle", function(e)
  local view = require("diffview.lib").get_current_view()

  if view then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen " .. e.args)
  end
end, { nargs = "*" })

return {
  { "sindrets/diffview.nvim",
    opts = {
      enhanced_diff_hl = true,
    }
  },
}
