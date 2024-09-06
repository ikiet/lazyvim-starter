-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.showtabline = 0
vim.g.autoformat = false
vim.g.lazyvim_php_lsp = "intelephense"
vim.opt.spell = false
vim.opt.spelllang = { "en", "cjk" }
vim.opt.spelloptions:append({ 'noplainbuffer', "camel" })
-- Options for the LazyVim statuscolumn
vim.g.lazyvim_statuscolumn = {
  folds_open = true, -- show fold sign when fold is open
  folds_githl = true, -- highlight fold sign with git sign color
}

local utils = require("lazyvim.util").ui

-- csutomize statuscolumn to show both staged & unstaged sign
_G.statuscolumn = function()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"

  local components = { "", "", "", "" } -- left, middle, right, optional

  local show_open_folds = vim.g.lazyvim_statuscolumn and vim.g.lazyvim_statuscolumn.folds_open
  local use_githl = vim.g.lazyvim_statuscolumn and vim.g.lazyvim_statuscolumn.folds_githl

  if show_signs then
    local signs = utils.get_signs(buf, vim.v.lnum)

    ---@type Sign?,Sign?,Sign?
    local left, middle, fold, githl, optional_middle
    -- check length of signs
    for _, s in ipairs(signs) do
      if s.name and (s.name:find("GitSign") or s.name:find("MiniDiffSign")) then
        if s.name:find("GitSignsStaged") then
          middle = s
        else
          optional_middle = s
          if use_githl then
            githl = s["texthl"]
          end
        end
      else
        left = s
      end
    end

    vim.api.nvim_win_call(win, function()
      if vim.fn.foldclosed(vim.v.lnum) >= 0 then
        fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = githl or "Folded" }
      elseif
        show_open_folds
        and not LazyVim.ui.skip_foldexpr[buf]
        and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">"
      then -- fold start
        fold = { text = vim.opt.fillchars:get().foldopen or "", texthl = githl }
      end
    end)
    -- Left: mark or non-git sign
    components[1] = utils.icon(utils.get_mark(buf, vim.v.lnum) or left)
    -- Right: fold icon or git sign (only if file)
    components[2] = is_file and utils.icon(middle) or ""
    components[3] = is_file and (optional_middle or fold) and utils.icon(fold or optional_middle) or ""
  end
  -- Numbers in Neovim are weird
  -- They show when either number or relativenumber is true
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.fn.has("nvim-0.11") == 1 then
      components[4] = "%l" -- 0.11 handles both the current and other lines with %l
    else
      if vim.v.relnum == 0 then
        components[4] = is_num and "%l" or "%r" -- the current line
      else
        components[4] = is_relnum and "%r" or "%l" -- other lines
      end
    end
    components[4] = "%=" .. components[4] .. " " -- right align
  end

  if vim.v.virtnum ~= 0 then
    components[4] = "%= "
  end

  return table.concat(components, "")
end

vim.opt.statuscolumn = [[%!v:lua.statuscolumn()]]
