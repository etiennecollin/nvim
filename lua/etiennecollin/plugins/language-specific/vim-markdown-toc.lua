return {
  "mzlogin/vim-markdown-toc",
  cmd = { "GenTocGFM", "GenTocRedcarpet", "GenTocGitLab", "GenTocMarked", "UpdateToc", "RemoveToc" },
  ft = "markdown",
  config = function()
    vim.g.vmt_auto_update_on_save = 0
    vim.g.vmt_include_headings_before = 0
    vim.g.vmt_list_item_char = "-"
  end,
}
