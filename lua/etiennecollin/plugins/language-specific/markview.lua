return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Lazy loading is done by the plugin
  dependencies = { "saghen/blink.cmp" },
  opts = {
    markdown = {
      list_items = {
        shift_width = vim.opt.tabstop,
      },
    },
  },
}
