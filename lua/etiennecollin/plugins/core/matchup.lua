return {
  "andymass/vim-matchup",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    treesitter = {
      stopline = 500,
      disable_virtual_text = false,
    },
  },
}
