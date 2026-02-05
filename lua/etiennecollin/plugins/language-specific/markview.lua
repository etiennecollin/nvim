return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = { "saghen/blink.cmp" },
  opts = {
    markdown = {
      list_items = {
        shift_width = vim.opt.tabstop,
      },
    },
  },
}
