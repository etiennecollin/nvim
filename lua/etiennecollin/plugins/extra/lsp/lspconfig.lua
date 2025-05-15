return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    { "mason-org/mason-lspconfig.nvim", dependencies = "mason-org/mason.nvim", config = false },
  },
  config = function()
    -----------------------------------------------------------------------
    -- Configure LSPs
    -----------------------------------------------------------------------
    ---@type vim.lsp.Config
    local base_config = {
      capabilities = require("etiennecollin.utils.local").get_lsp_capabilities(),
      on_attach = require("etiennecollin.core.mappings.plugin").lsp,
    }

    -- Set default capabilities and on_attach function for all servers
    vim.lsp.config("*", base_config)

    -- Load custom LSP configurations
    for server_name, custom_config in pairs(require("etiennecollin.config_lsp")) do
      -- Merge the custom configuration with the base configuration
      -- If there are conflicts in the keys, the custom configuration will take precedence
      vim.lsp.config(server_name, vim.tbl_deep_extend("force", base_config, custom_config or {}))
    end

    -----------------------------------------------------------------------
    -- Install LSPs with mason
    -----------------------------------------------------------------------
    require("mason-lspconfig").setup({
      ensure_installed = require("etiennecollin.config").ensure_installed_lsps,
      automatic_enable = {
        exclude = {},
      },
    })
  end,
}
