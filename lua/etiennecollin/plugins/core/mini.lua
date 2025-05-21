return {
  "echasnovski/mini.nvim",
  event = { "BufReadPre", "BufNewFile" },
  version = "*",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local ai = require("mini.ai")
    ai.setup({
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        F = ai.gen_spec.treesitter({
          a = "@function.outer",
          i = "@function.inner",
        }, {}),
        c = ai.gen_spec.treesitter({
          a = "@class.outer",
          i = "@class.inner",
        }, {}),
      },
    })

    require("mini.align").setup()
    require("mini.pairs").setup()
    require("mini.splitjoin").setup()
    require("mini.surround").setup({
      mappings = {
        add = "s", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "rs", -- Replace surrounding
        update_n_lines = "", -- Update `n_lines`
        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    })
  end,
}
