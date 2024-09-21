return {
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>sr",
        function()
          local grug_far = require("grug-far")

          if not grug_far.has_instance("Grug Far") then
            grug_far.open({
              instanceName = "Grug Far",
              transient = false,
              staticTitle = "Find and Replace",
            })
          else
            grug_far.open_instance("Grug Far")
          end
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
}
