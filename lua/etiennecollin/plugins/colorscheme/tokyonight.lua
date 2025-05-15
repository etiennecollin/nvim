return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  lazy = true,
  priority = 1000,
  opts = {
    style = "moon",
    -- Adjusts the brightness of the colors of the **Day** style.
    -- Number between 0 and 1, from dull to vibrant colors
    day_brightness = 0.4,
    dim_inactive = false, -- Dim inactive windows
  },
}
