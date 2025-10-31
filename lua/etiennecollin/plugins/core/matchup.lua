return {
  "andymass/vim-matchup",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    treesitter = {
      stopline = 500,
      disable_virtual_text = false,
    },
  },
}
