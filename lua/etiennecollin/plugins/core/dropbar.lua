return {
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    bar = {
      sources = function()
        local sources = require("dropbar.sources")
        local utils = require("dropbar.utils")
        local filename = {
          get_symbols = function(buff, win, cursor)
            local path = sources.path.get_symbols(buff, win, cursor)
            return { path[#path] }
          end,
        }
        return {
          filename,
          utils.source.fallback({
            sources.lsp,
            sources.treesitter,
            sources.markdown,
          }),
        }
      end,
    },
  },
  config = function(_, opts)
    require("dropbar").setup(opts)
    require("etiennecollin.core.mappings.plugin").dropbar()
  end,
}
