return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      "nvim-dap-ui",
      "lazy.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "obsidian.nvim", words = { "Obsidian" } },
    },
    integrations = {
      lspconfig = true,
      cmp = false,
      coq = false,
    },
  },
}
