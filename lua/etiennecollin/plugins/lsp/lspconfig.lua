return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		{ "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
	},
	config = function()
		-----------------------------------------------------------------------
		-- Install LSPs with mason
		-----------------------------------------------------------------------
		require("mason-lspconfig").setup({
			ensure_installed = require("etiennecollin.config").ensure_installed_lsps,
			automatic_installation = true,
		})

		-----------------------------------------------------------------------
		-- Setup handlers
		-----------------------------------------------------------------------
		---@type vim.lsp.Config
		local base_config = {
			capabilities = require("etiennecollin.utils.local").get_lsp_capabilities(),
			on_attach = require("etiennecollin.core.mappings.plugin").lsp,
		}

		-- Set default capabilities and on_attach function for all servers
		vim.lsp.config("*", base_config)

		-- Setup specific servers
		require("mason-lspconfig").setup_handlers({
			-- This is the default handler for all servers
			function(server_name)
				-- Load custom configuration if it exists
				local custom_config = require("etiennecollin.config_lsp")[server_name]
				-- Merge the custom configuration with the base configuration
				-- If there are conflicts in the keys, the custom configuration will take precedence
				vim.lsp.config(server_name, vim.tbl_deep_extend("force", base_config, custom_config or {}))
				vim.lsp.enable(server_name)
			end,
			-- Do not configure rust_analyzer as that's handled by rustaceanvim
			["rust_analyzer"] = function() end,
		})
	end,
}
