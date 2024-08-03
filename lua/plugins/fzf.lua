local actions = require("fzf-lua.actions")

local toggle_root = function(_, ctx)
  local o = vim.deepcopy(ctx.__call_opts)
  o.root = o.root == false
  o.cwd = nil
  o.resume = false
  o.buf = ctx.__CTX.bufnr
  LazyVim.pick.open(ctx.__INFO.cmd, o)
end

local clearQuery = function(_, ctx)
  local o = vim.deepcopy(ctx.__call_opts)
  o.query = ""
  LazyVim.pick.open(ctx.__INFO.cmd, o)
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = {
      keymap = {
        -- Below are the default binds, setting any value in these tables will override
        -- the defaults, to inherit from the defaults change [1] from `false` to `true`
        builtin = {
          ["<M-/>"] = "toggle-help",
          -- Only valid with the 'builtin' previewer
          ["<M-w>"] = "toggle-preview-wrap",
          ["<M-p>"] = "toggle-preview",
          -- Rotate preview clockwise/counter-clockwise
          ["<M-S-j>"] = "preview-page-down",
          ["<M-S-k>"] = "preview-page-up",
          ["<M-j>"] = "preview-down",
          ["<M-k>"] = "preview-up",
        },
      },

      files = {
        formatter = "path.filename_first",
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-c"] = clearQuery,
        },
      },
      git = {
        status = {
          actions = {
            ["ctrl-u"] = { fn = actions.git_unstage, reload = true },
            ["ctrl-s"] = { fn = actions.git_stage, reload = true },
          },
        },
        commits = {
          actions = {
            ["ctrl-r"] = toggle_root,
            ["alt-c"] = clearQuery,
          },
        },
        bcommits = {
          actions = {
            ["ctrl-r"] = toggle_root,
            ["alt-c"] = clearQuery,
          },
        },
      },
      winopts = {
        height = 0.9,
        width = 0.9,
        preview = {
          horizontal = "right:75%", -- right|left:size
        },
      },
    },
    keys = {
      { "<leader>sc", false },
      { "<leader><space>", false },
      { "<leader>,", false },
      { "<leader>/", false },

      -- find
      { "<leader>ff", LazyVim.pick("files", { root = true, resume = true }), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.pick("files", { root = true, resume = false }), desc = "Find Files" },
      { "<leader>fr", LazyVim.pick("oldfiles", { resume = true }), desc = "Recent (Resume)" },
      { "<leader>fR", LazyVim.pick("oldfiles", { resume = false }), desc = "Recent" },
      -- git
      { "<leader>gc", LazyVim.pick("git_commits", { resume = true }), desc = "Commits (Resume)" },
      { "<leader>gC", LazyVim.pick("git_commits", { resume = false }), desc = "Commits" },
      { "<leader>gt", LazyVim.pick("git_bcommits", { resume = true }), desc = "Buffer Commits (Resume)" },
      { "<leader>gT", LazyVim.pick("git_bcommits", { resume = false }), desc = "Buffer Commits" },
      { "<leader>gs", LazyVim.pick("git_status", { resume = true }), desc = "Status (Resume)" },
      { "<leader>gS", LazyVim.pick("git_status", { resume = false }), desc = "Status" },
      -- search
      { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Grep Buffer" },
      { "<leader>sg", LazyVim.pick("live_grep_resume"), desc = "Grep (Resume)" },
      { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep" },
    },
  },
}
