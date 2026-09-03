return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    diff = {
      ignore_trim_whitespace = false, -- Ignore leading/trailing whitespace changes (like diffopt+=iwhite)
      compute_moves = false, -- Detect moved code blocks (opt-in, matches VSCode experimental.showMoves)
    },
    explorer = {
      view_mode = "tree", -- "list" or "tree"
    },
  },
  config = function(_, opts)
    require("codediff").setup(opts)

    local diagnostics_enabled
    local group = vim.api.nvim_create_augroup("etiennecollin-codediff", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodeDiffOpen",
      callback = function()
        diagnostics_enabled = vim.diagnostic.is_enabled()
        vim.diagnostic.hide()
      end,
      desc = "Disable diagnostics when CodeDiff opens.",
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodeDiffClose",
      callback = function()
        if diagnostics_enabled then
          vim.diagnostic.show()
        else
          vim.diagnostic.hide()
        end
      end,
      desc = "Restore diagnostics when CodeDiff closes.",
    })
  end,
}
