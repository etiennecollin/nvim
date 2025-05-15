return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics",
    },
    {
      "<leader>xb",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ...",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List",
    },
    {
      "[t",
      function()
        require("trouble").prev({ skip_groups = true, jump = true })
      end,
      desc = "Previous Trouble",
    },
    {
      "]t",
      function()
        require("trouble").next({ skip_groups = true, jump = true })
      end,
      desc = "Next Trouble",
    },
  },
  specs = {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          actions = require("trouble.sources.snacks").actions,
          win = {
            input = {
              keys = {
                ["<c-t>"] = {
                  "trouble_open",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
      })
    end,
  },
  config = true,
}
