return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("multicursor-nvim").setup()
    require("etiennecollin.core.mappings.plugin").multicursor()

    -- Customize how cursors look.
    -- local hl = vim.api.nvim_set_hl
    -- hl(0, "MultiCursorCursor", { reverse = true })
    -- hl(0, "MultiCursorVisual", { link = "Visual" })
    -- hl(0, "MultiCursorSign", { link = "SignColumn" })
    -- hl(0, "MultiCursorMatchPreview", { link = "Search" })
    -- hl(0, "MultiCursorDisabledCursor", { reverse = true })
    -- hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    -- hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
