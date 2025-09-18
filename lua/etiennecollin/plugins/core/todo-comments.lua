return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
    highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
  },
}
