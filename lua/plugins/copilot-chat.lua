return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      window = {
        width = 0.7,
        height = 0.7,
        layout = "float",
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
      },
      mappings = {
        close = {
          normal = "<Esc>",
        },
        reset = {
          normal = "<C-l>",
          insert = "<C-l>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        yank_diff = {
          normal = "gy",
          insert = "<C-c>",
        },
        show_diff = {
          normal = "gd",
          insert = "<C-d>",
        },
        show_system_prompt = {
          normal = "gp",
        },
        show_user_selection = {
          normal = "gs",
        },
      },
    },
  },
}
