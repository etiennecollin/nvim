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
}
