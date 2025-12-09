return {
  "saghen/blink.pairs",
  enabled = false,
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = "saghen/blink.download",
  opts = {
    highlights = {
      enabled = false,
    },
  },
}
