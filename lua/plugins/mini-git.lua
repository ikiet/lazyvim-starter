return {
  {
    "echasnovski/mini-git",
    version = "*",
    main = "mini.git",
    opts = {
      -- No need to copy this inside `setup()`. Will be used automatically.
      -- General CLI execution
      job = {
        -- Path to Git executable
        git_executable = "git",

        -- Timeout (in ms) for each job before force quit
        timeout = 30000,
      },

      -- Options for `:Git` command
      command = {
        -- Default split direction
        split = "vertical",
      },
    },
  },
}
