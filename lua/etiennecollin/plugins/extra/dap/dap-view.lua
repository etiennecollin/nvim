return {
  "igorlfs/nvim-dap-view",
  -- let the plugin lazy load itself
  lazy = false,
  version = "1.*",
  ---@module 'dap-view'
  ---@type dapview.Config
  opts = {
    winbar = {
      show = true,
      -- You can add a "console" section to merge the terminal with the other views
      sections = { "watches", "scopes", "threads", "repl", "breakpoints", "exceptions", "sessions" },
      default_section = "scopes",
      controls = {
        enabled = true,
      },
    },
    windows = {
      size = 0.35,
      position = "below",
      terminal = {
        size = 0.5,
        position = "right",
      },
    },
    render = {
      ---@param a dap.Variable
      ---@param b dap.Variable
      ---@return boolean
      sort_variables = function(a, b)
        return a.name:lower() < b.name:lower()
      end,
    },
    auto_toggle = true,
  },
  config = function(_, opts)
    require("dap-view").setup(opts)
    require("etiennecollin.core.mappings.plugin").dapview()
  end,
}
