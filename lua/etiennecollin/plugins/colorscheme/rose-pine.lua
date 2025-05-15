return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = true,
  priority = 1000,
  opts = {
    variant = "auto", -- Follows vim.opt.background
    dark_variant = "moon", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,
    highlight_groups = {
      CurSearch = { fg = "base", bg = "leaf", inherit = false },
      Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
      -- StatusLine = { fg = "love", bg = "love", blend = 10 },
      -- StatusLineNC = { fg = "subtle", bg = "surface" },
    },
  },
}
