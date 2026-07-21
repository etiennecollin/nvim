return {
  "michaelrommel/nvim-silicon",
  cmd = "Silicon",
  opts = {
    font = "Maple Mono NF=34",
    theme = "gruvbox-dark",
    background = nil,
    -- background_image = vim.fn.expand("~/Pictures/wallpapers/ancient_bristlecone_pine_forest.jpg"),
    shadow_color = "#161618",
    to_clipboard = true,
    line_offset = 0,
    window_title = function()
      local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      local filename = vim.fn.fnamemodify(file, ":t:r")
      return filename
    end,
    output = function()
      local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      local filename = vim.fn.fnamemodify(file, ":t:r")

      local dir = vim.fn.expand("~/Pictures/code-snippets")
      vim.fn.mkdir(dir, "p")

      local timestamp = os.date("!%Y%m%dT%H%M%S")

      return string.format("%s/%s_%s_code.png", dir, timestamp, filename)
    end,
  },
  init = function()
    require("etiennecollin.core.mappings.plugin").silicon()
  end,
}
