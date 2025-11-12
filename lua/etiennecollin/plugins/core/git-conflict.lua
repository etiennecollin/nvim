return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = false,
    list_opener = "copen",
    highlights = {
      incoming = "DiffAdd",
      ancestor = "DiffChange",
      current = "DiffText",
    },
  },
}
