vim.cmd([[
hi StartLogo0 ctermfg=41 guifg=#29d142
hi StartLogo1 ctermfg=41 guifg=#00d05f
hi StartLogo2 ctermfg=42 guifg=#00ce79
hi StartLogo3 ctermfg=42 guifg=#00cb92
hi StartLogo4 ctermfg=43 guifg=#00c8aa
hi StartLogo5 ctermfg=43 guifg=#00c4c0
hi StartLogo6 ctermfg=38 guifg=#00bfd3
hi StartLogo7 ctermfg=38 guifg=#00bae3
hi StartLogo8 ctermfg=39 guifg=#00b4f0
hi StartLogo9 ctermfg=39 guifg=#00adf8
hi StartLogo10 ctermfg=39 guifg=#00a6fc
hi StartLogo11 ctermfg=39 guifg=#009dfc
hi StartLogo12 ctermfg=33 guifg=#0095f8
hi StartLogo13 ctermfg=33 guifg=#008bf0
hi StartLogoPop0 ctermfg=125 guifg=#bd075c
hi StartLogoPop1 ctermfg=125 guifg=#b7015f
hi StartLogoPop2 ctermfg=125 guifg=#b00062
hi StartLogoPop3 ctermfg=125 guifg=#a90064
hi StartLogoPop4 ctermfg=125 guifg=#a20066
hi StartLogoPop5 ctermfg=89 guifg=#9a0069
hi StartLogoPop6 ctermfg=89 guifg=#92006a
hi StartLogoPop7 ctermfg=89 guifg=#8a006c
]])

local logo = {
  [[    ███╗   ███╗ █████╗ ██╗  ██╗███████╗   ]],
  [[    ████╗ ████║██╔══██╗██║ ██╔╝██╔════╝   ]],
  [[    ██╔████╔██║███████║█████╔╝ █████╗     ]],
  [[    ██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝     ]],
  [[    ██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗   ]],
  [[    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ]],
  [[      ██████╗ ██████╗  ██████╗ ██╗        ]],
  [[     ██╔════╝██╔═══██╗██╔═══██╗██║        ]],
  [[     ██║     ██║   ██║██║   ██║██║        ]],
  [[     ██║     ██║   ██║██║   ██║██║        ]],
  [[     ╚██████╗╚██████╔╝╚██████╔╝███████╗   ]],
  [[      ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝   ]],
  [[███████╗████████╗██╗   ██╗███████╗███████╗]],
  [[██╔════╝╚══██╔══╝██║   ██║██╔════╝██╔════╝]],
  [[███████╗   ██║   ██║   ██║█████╗  █████╗  ]],
  [[╚════██║   ██║   ██║   ██║██╔══╝  ██╔══╝  ]],
  [[███████║   ██║   ╚██████╔╝██║     ██║     ]],
  [[╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝     ]],
}

local function get_each_line_color(lines, popStart, popEnd)
  local out = {}
  for i, line in ipairs(lines) do
    local hi = "StartLogo" .. i
    if i > popStart and i <= popEnd then
      hi = "StartLogoPop" .. i - popStart
    elseif i > popStart then
      hi = "StartLogo" .. i - popStart
    else
      hi = "StartLogo" .. i
    end
    table.insert(out, { hi = hi, line = line })
  end
  return out
end

local function header_chars()
  return get_each_line_color(logo, 6, 12)
end

--- Map over the headers, setting a different color for each line.
--- This is done by setting the Highlight to StartLogoN, where N is the row index.
--- Define StartLogo1..StartLogoN to get a nice gradient.
local function header_color()
  local lines = {}
  for _, lineConfig in pairs(header_chars()) do
    local hi = lineConfig.hi
    local line_chars = lineConfig.line
    local line = {
      type = "text",
      val = line_chars,
      opts = {
        hl = hi,
        shrink_margin = false,
        position = "center",
      },
    }
    table.insert(lines, line)
  end

  local output = {
    type = "group",
    val = lines,
    opts = { position = "center" },
  }

  return output
end

return {
  "goolord/alpha-nvim",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       LazyVim.pick()),
      dashboard.button("n", " " .. " New file",        [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button("r", " " .. " Recent files",    LazyVim.pick("oldfiles")),
      dashboard.button("g", " " .. " Find text",       LazyVim.pick("live_grep")),
      dashboard.button("c", " " .. " Config",          LazyVim.pick.config_files()),
      dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 5
    dashboard.opts.layout[2] = header_color()
    dashboard.opts.layout[3].val = 3
    return dashboard
  end,
}
