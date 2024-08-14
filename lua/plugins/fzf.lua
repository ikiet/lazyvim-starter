local actions = require("fzf-lua.actions")

local toggle_root = function(_, ctx)
  local o = vim.deepcopy(ctx.__call_opts)
  local winopts = vim.deepcopy(ctx.winopts)
  local basename = winopts.title.gsub(winopts.title, "%(.-%)", "")
  if o.root == true then
    winopts.title = basename .. "(Cwd)"
  else
    winopts.title = basename .. "(Root)"
  end

  o.root = o.root == false
  o.cwd = nil
  o.resume = false
  o.buf = ctx.__CTX.bufnr
  o.winopts = winopts
  LazyVim.pick.open(ctx.__INFO.cmd, o)
end

local clear_query = function(_, ctx)
  local o = vim.deepcopy(ctx.__call_opts)
  o.query = ""
  LazyVim.pick.open(ctx.__INFO.cmd, o)
end

local grep_clear_search_and_query = function(_, ctx)
  local o = vim.deepcopy(ctx.__call_opts)
  o.search = ""
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
        formatter = { "path.filename_first", 2 },
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-c"] = clear_query,
        },
      },
      oldfiles = {
        include_current_session = true,
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-c"] = clear_query,
        },
      },
      grep = {
        formatter = { "path.filename_first", 2 },
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-c"] = grep_clear_search_and_query,
        },
      },
      git = {
        status = {
          actions = {
            ["ctrl-u"] = { fn = actions.git_unstage, reload = true },
            ["ctrl-s"] = { fn = actions.git_stage, reload = true },
            ["ctrl-r"] = toggle_root,
            ["alt-c"] = clear_query,
          },
        },
        commits = {
          actions = {
            ["ctrl-r"] = toggle_root,
            ["alt-c"] = clear_query,
          },
        },
        bcommits = {
          actions = {
            ["ctrl-r"] = toggle_root,
            ["alt-c"] = clear_query,
          },
        },
      },
      winopts = {
        height = 0.9,
        width = 0.9,
        preview = {
          horizontal = "right:70%", -- right|left:size
        },
      },
    },
    keys = {
      { "<leader>sc", false },
      { "<leader><space>", false },
      { "<leader>,", false },
      { "<leader>/", false },

      -- find
      {
        "<leader>ff",
        LazyVim.pick("files", { root = true, resume = true, winopts = { title = "Files(Root)" } }),
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        LazyVim.pick("files", { root = true, resume = false, winopts = { title = "Files(Root)" } }),
        desc = "Find Files",
      },
      {
        "<leader>fr",
        LazyVim.pick("oldfiles", { root = true, resume = true, winopts = { title = "OldFiles(Root)" } }),
        desc = "Recent (Resume)",
      },
      {
        "<leader>fR",
        LazyVim.pick("oldfiles", { root = true, resume = false, winopts = { title = "OldFiles(Root)" } }),
        desc = "Recent",
      },
      -- git
      {
        "<leader>gc",
        LazyVim.pick("git_commits", { root = true, resume = true, winopts = { title = "Git Commits(Root)" } }),
        desc = "Commits (Resume)",
      },
      {
        "<leader>gC",
        LazyVim.pick("git_commits", { root = true, resume = false, winopts = { title = "Git Commits(Root)" } }),
        desc = "Commits",
      },
      {
        "<leader>gt",
        LazyVim.pick("git_bcommits", { root = true, resume = true, winopts = { title = "Buffer Commits(Root)" } }),
        desc = "Buffer Commits (Resume)",
      },
      {
        "<leader>gT",
        LazyVim.pick("git_bcommits", { root = true, resume = false, winopts = { title = "Buffer Commits(Root)" } }),
        desc = "Buffer Commits",
      },
      {
        "<leader>gs",
        LazyVim.pick("git_status", { root = true, resume = true, winopts = { title = "Git Status(Root)" } }),
        desc = "Status (Resume)",
      },
      {
        "<leader>gS",
        LazyVim.pick("git_status", { root = true, resume = false, winopts = { title = "Git Status(Root)" } }),
        desc = "Status",
      },
      -- search
      { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Grep Buffer" },
      {
        "<leader>sg",
        LazyVim.pick("live_grep", { root = true, resume = true, winopts = { title = "Grep(Root)" } }),
        desc = "Grep (Resume)",
      },
      {
        "<leader>sG",
        LazyVim.pick("live_grep", { root = true, resume = false, winopts = { title = "Grep(Root)" } }),
        desc = "Grep",
      },
    },
  },
}
