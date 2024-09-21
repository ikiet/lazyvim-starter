local Util = {}

function Util.reveal_in_finder(uri)
  local file_exists = vim.uv.fs_stat(uri) ~= nil
  if not file_exists then
    local msg = {
      "File does not exist",
      vim.inspect(uri),
    }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.ERROR)
    return
  end

  local cmd = { "open", "-R", uri }
  local ret = vim.fn.jobstart(cmd, { detach = true })
  if ret <= 0 then
    local msg = {
      "Failed to open uri",
      ret,
      vim.inspect(cmd),
    }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.ERROR)
  end
end

return Util
