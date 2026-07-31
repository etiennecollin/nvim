return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_port = "42697"
    vim.g.mkdp_page_title = "${name}.md"
    vim.g.mkdp_theme = "light"
    vim.g.mkdp_combine_preview = 1
    vim.g.mkdp_combine_preview_auto_refresh = 1
    vim.g.mkdp_preview_options = {
      uml = { imageFormat = "svg", server = "http://127.0.0.1:8091" },
    }
  end,
}
