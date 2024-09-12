if true then return {} end
local CSPELL_CONFIG_FILES = {
  "cspell.json",
  ".cspell.json",
  "cSpell.json",
  ".cspell.json",
  ".cspell.config.json",
}

---@param filename string
---@param cwd string
---@return string|nil
local function find_file(filename, cwd)
  ---@type string|nil
  local current_dir = cwd
  local root_dir = "/"

  repeat
    local file_path = current_dir .. "/" .. filename
    local stat = vim.uv.fs_stat(file_path)
    if stat and stat.type == "file" then
      return file_path
    end

    current_dir = vim.uv.fs_realpath(current_dir .. "/..")
  until current_dir == root_dir

  return nil
end

--- Find the first cspell.json file in the directory tree
---@param cwd string
---@return string|nil
local find_cspell_config_path = function(cwd)
  for _, file in ipairs(CSPELL_CONFIG_FILES) do
    local path = find_file(file, cwd or vim.loop.cwd())
    if path then
      return path
    end
  end
  return nil
end

--- Find the project .vscode directory, if any
---@param cwd string
---@return string|nil
local function find_vscode_config_dir(cwd)
  ---@type string|nil
  local current_dir = cwd
  local root_dir = "/"

  repeat
    local dir_path = current_dir .. "/.vscode"
    local stat = vim.loop.fs_stat(dir_path)
    if stat and stat.type == "directory" then
      return dir_path
    end

    current_dir = vim.loop.fs_realpath(current_dir .. "/..")
  until current_dir == root_dir

  return nil
end

return {
  {
    "davidmh/cspell.nvim",
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local config = {
        find_json = function(cwd)
          local vscode_dir = find_vscode_config_dir(cwd)
          if vscode_dir ~= nil then
            local path = find_cspell_config_path(vscode_dir)
            if path ~= nil then
              print("Found cspell config at: " .. path)
              return path
            end
            print("Cannot find cspell config!")
          end
          local path = find_cspell_config_path(cwd)
          if path ~= nil then
            print("Found cspell config at: " .. path)
            return path
          end
          print("Cannot find cspell config!")
        end,
        decode_json = function(json)
          return vim.json.decode(json)
        end,
      }
      local cspell = require("cspell")
      opts.sources = vim.list_extend(opts.sources or {}, {
        cspell.diagnostics.with({
          config = config,
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["WARN"]
          end,
        }),
        cspell.code_actions.with({ config = config }),
      })
    end,
  },
  {

    "williamboman/mason.nvim",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "cspell",
      },
    },
  },
}
