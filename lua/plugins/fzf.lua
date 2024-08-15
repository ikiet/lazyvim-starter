local actions = require("fzf-lua.actions")
local path = require("fzf-lua.path")

local copy_path = function(selected, opts, absoluteMode)
  -- Lua 5.1 goto compatiblity hack (function wrap)
  local entry = path.entry_to_file(selected[1], opts, opts._uri)
  -- "<none>" could be set by `autocmds`
  if entry.path == "<none>" then
    return
  end
  local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
  -- Something is not right, goto next entry
  if not fullpath then
    return
  end
  local cwd = opts.cwd or opts._cwd or uv.cwd()
  if path.is_absolute(fullpath) and not absoluteMode then
    fullpath = path.relative_to(fullpath, cwd)
  elseif not path.is_absolute(fullpath) and absoluteMode then
    fullpath = path.join({ cwd, fullpath })
  end
  vim.fn.setreg("+", fullpath, "c")
end

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

_G.fzf_dirs = function(opts)
  local fzf_lua = require("fzf-lua")
  opts = opts or {}
  opts.prompt = "Directories> "
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ["default"] = function(selected)
      vim.cmd("e " .. selected[1])
    end,
  }
  fzf_lua.fzf_exec("fd --type d", opts)
end

vim.keymap.set("n", "<leader>fd", _G.fzf_dirs)

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
          ["alt-y"] = function(selected, opts)
            copy_path(selected, opts, false)
          end,
          ["alt-Y"] = function(selected, opts)
            copy_path(selected, opts, true)
          end,
        },
      },
      oldfiles = {
        include_current_session = true,
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-c"] = clear_query,
          ["alt-y"] = function(selected, opts)
            copy_path(selected, opts, false)
          end,
          ["alt-Y"] = function(selected, opts)
            copy_path(selected, opts, true)
          end,
        },
      },
      buffers = {
        formatter = { "path.filename_first", 2 },
      },
      grep = {
        formatter = { "path.filename_first", 2 },
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-c"] = grep_clear_search_and_query,
          ["alt-y"] = function(selected, opts)
            copy_path(selected, opts, false)
          end,
          ["alt-Y"] = function(selected, opts)
            copy_path(selected, opts, true)
          end,
        },
      },
      git = {
        status = {
          formatter = { "path.filename_first", 2 },
          actions = {
            ["ctrl-u"] = { fn = actions.git_unstage, reload = true },
            ["ctrl-s"] = { fn = actions.git_stage, reload = true },
            ["ctrl-r"] = toggle_root,
            ["alt-c"] = clear_query,
            ["alt-y"] = function(selected, opts)
              copy_path(selected, opts, false)
            end,
            ["alt-Y"] = function(selected, opts)
              copy_path(selected, opts, true)
            end,
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
