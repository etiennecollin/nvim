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
		local capabilities = require("etiennecollin.utils").get_lsp_capabilities()
		local on_attach = require("etiennecollin.core.mappings.plugin").lsp

		local default_handler = function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end

		require("mason-lspconfig").setup_handlers({
			default_handler,
			-- Specific servers
			["rust_analyzer"] = function() end,
			["basedpyright"] = function()
				require("etiennecollin.plugins.lsp.servers.basedpyright")(capabilities, on_attach)
			end,
			["jdtls"] = function()
				require("etiennecollin.plugins.lsp.servers.jdtls")(capabilities, on_attach)
			end,
			["lua_ls"] = function()
				require("etiennecollin.plugins.lsp.servers.lua_ls")(capabilities, on_attach)
			end,
			["tinymist"] = function()
				require("etiennecollin.plugins.lsp.servers.tinymist")(capabilities, on_attach)
			end,
			["clangd"] = function()
				require("etiennecollin.plugins.lsp.servers.clangd")(capabilities, on_attach)
			end,
			["tailwindcss"] = function()
				require("etiennecollin.plugins.lsp.servers.tailwindcss")(capabilities, on_attach)
			end,
			["marksman"] = function()
				require("etiennecollin.plugins.lsp.servers.marksman")(capabilities, on_attach)
			end,
		})
	end,
}
