return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
    require("nvim-treesitter").install(require("etiennecollin.config").ensure_installed_treesitter)

    -- local installed_parsers = require("nvim-treesitter.config").get_installed("parsers")
    -- local ensure_installed_parsers = require("etiennecollin.config").ensure_installed_treesitter
    --
    -- -- Find missing parsers
    -- local not_installed = vim.tbl_filter(function(parser)
    --   return not vim.tbl_contains(installed_parsers, parser)
    -- end, ensure_installed_parsers)
    --
    -- -- Install missing parsers
    -- if #not_installed > 0 then
    --   require("nvim-treesitter").install(not_installed)
    -- end
  end,
}
