return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
    highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
  },
}
