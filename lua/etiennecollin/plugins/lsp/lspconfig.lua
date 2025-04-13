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
		-- Set default capabilities and on_attach function for all servers
		vim.lsp.config("*", {
			capabilities = require("etiennecollin.utils.local").get_lsp_capabilities(),
			on_attach = require("etiennecollin.core.mappings.plugin").lsp,
		})

		-- Setup specific servers
		require("mason-lspconfig").setup_handlers({
			-- This is the default handler for all servers
			function(server_name)
				-- Load custom configuration if it exists
				local configs = require("etiennecollin.config_lsp")
				if configs[server_name] and type(configs[server_name]) == "function" then
					configs[server_name]()
				end
				vim.lsp.enable(server_name)
			end,
			-- Do not configure rust_analyzer as that's handled by rustaceanvim
			["rust_analyzer"] = function() end,
		})
	end,
}
