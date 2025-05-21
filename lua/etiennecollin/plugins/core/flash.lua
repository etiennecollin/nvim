return {
  "folke/flash.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    labels = "arstgmneioqwfpbjluyzxcdvkh",
    jump = {
      nohlsearch = true,
      autojump = true,
    },
    modes = {
      char = {
        config = function(opts)
          local in_operator_pending = vim.fn.mode(true):find("o")

          -- Autohide flash when in operator-pending mode
          opts.autohide = opts.autohide or in_operator_pending

          -- Enable jump-labels only when not using a count
          -- and when not in operator-pending mode
          opts.jump_labels = opts.jump_labels and vim.v.count == 0 and not in_operator_pending
        end,
        jump_labels = true,
        jump = {
          autojump = true,
        },
      },
      treesitter = {
        labels = "arstgmneioqwfpbjluyzxcdvkh",
      },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)
    require("etiennecollin.core.mappings.plugin").flash()
  end,
}
