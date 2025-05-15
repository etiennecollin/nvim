return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*",
  opts = {
    keymaps = {
      insert = false,
      insert_line = false,
      normal = "gs",
      normal_cur = "gss",
      normal_line = "gS",
      normal_cur_line = "gSS",
      visual = "gS",
      visual_line = "gS",
      delete = "ds",
      change = "cs",
      change_line = "cS",
    },
  },
}
