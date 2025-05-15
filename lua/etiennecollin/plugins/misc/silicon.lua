return {
  "michaelrommel/nvim-silicon",
  cmd = "Silicon",
  opts = {
    font = "Maple Mono NF=34",
    theme = "gruvbox-dark",
    background = nil,
    background_image = vim.fn.expand("~/Pictures/wallpapers/ancient_bristlecone_pine_forest.jpg"),
    shadow_color = "#161618",
    to_clipboard = true,
    line_offset = 0,
    window_title = function()
      local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      -- Fullname
      return vim.fn.fnamemodify(file, ":t")
    end,
    output = function()
      local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      -- Basename .. timestamp .. _code.png
      return vim.fn.fnamemodify(file, ":r") .. os.date("!%Y%m%dT%H%M%S") .. "_code.png"
    end,
  },
  init = function()
    require("etiennecollin.core.mappings.plugin").silicon()
  end,
}
