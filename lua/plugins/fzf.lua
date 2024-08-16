local actions = require("fzf-lua.actions")
local utils = require("fzf-lua.utils")
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

local function copy_path_silently(absoluteMode)
  return {
    fn = function(selected, opts)
      copy_path(selected, opts, absoluteMode)
    end,
    exec_silent = true,
  }
end

local git_commit = function(selected, opts)
  -- "reload" actions (fzf version >= 0.36) use field_index = "{q}"
  -- so the prompt input will be found in `selected[1]`
  -- previous fzf versions (or skim) restart the process instead
  -- so the prompt input will be found in `opts.last_query`
  local message = opts.last_query or selected[1]
  if type(message) ~= "string" or #message == 0 then
    utils.warn("Commit message cannot be empty, use prompt for input.")
  else
    if utils.input("Commit staged changes? [y/n]\n" .. message .. "\n") == "y" then
      local cmd_git_commit = path.git_cwd(opts.cmd_commit, opts)
      table.insert(cmd_git_commit, message)
      local output, rc = utils.io_systemlist(cmd_git_commit)
      if rc ~= 0 then
        utils.err(table.concat(output, "\n"))
      else
        utils.info(string.format("Commited: '%s'.", message))
      end
    end
  end
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
        fzf = {},
      },

      files = {
        formatter = { "path.filename_first", 2 },
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-y"] = copy_path_silently(false),
          ["alt-Y"] = copy_path_silently(true),
        },
      },
      oldfiles = {
        include_current_session = true,
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-y"] = copy_path_silently(false),
          ["alt-Y"] = copy_path_silently(true),
        },
      },
      buffers = {
        formatter = { "path.filename_first", 2 },
      },
      grep = {
        formatter = { "path.filename_first", 2 },
        actions = {
          ["ctrl-r"] = toggle_root,
          ["alt-y"] = copy_path_silently(false),
          ["alt-Y"] = copy_path_silently(true),
        },
      },
      git = {
        status = {
          formatter = { "path.filename_first", 2 },
          cmd_commit = { "git", "commit", "-m" },
          actions = {
            ["right"] = false,
            ["left"] = false,
            ["ctrl-s"] = { fn = actions.git_stage_unstage, reload = true },
            ["ctrl-r"] = toggle_root,
            ["alt-y"] = copy_path_silently(false),
            ["alt-Y"] = copy_path_silently(true),
            ["alt-k"] = { fn = git_commit, field_index = "{q}", reload = true },
          },
        },
        commits = {
          actions = {
            ["ctrl-r"] = toggle_root,
          },
        },
        bcommits = {
          actions = {
            ["ctrl-r"] = toggle_root,
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
      {
        "<leader>dd",
        "<cmd>FzfLua dap_breakpoints<cr>",
        desc = "Breakpoints",
      },
      {
        "<leader>gn",
        "<cmd>FzfLua git_branches<cr>",
        desc = "Git Branches",
      },
      {
        "<leader>gm",
        "<cmd>FzfLua git_stash<cr>",
        desc = "Git Stashes",
      },
    },
  },
}
