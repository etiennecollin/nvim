return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"folke/neodev.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
	},
	config = function()
		-----------------------------------------------------------------------
		-- Install LSPs with mason
		-----------------------------------------------------------------------
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "rust_analyzer", "jdtls", "ruff_lsp", "pyright" },
			automatic_installation = true,
		})

		-----------------------------------------------------------------------
		-- Setup handlers
		-----------------------------------------------------------------------
		local capabilities = require("etiennecollin.utils").get_lsp_capabilities()
		local on_attach = require("etiennecollin.core.remaps_plugin").lsp()

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
			["pylsp"] = function()
				require("etiennecollin.plugins.lsp.servers.pylsp")(capabilities, on_attach)
			end,
			["jdtls"] = function()
				require("etiennecollin.plugins.lsp.servers.jdtls")(capabilities, on_attach)
			end,
			["lua_ls"] = function()
				require("etiennecollin.plugins.lsp.servers.lua_ls")(capabilities, on_attach)
			end,
			["clangd"] = function()
				require("etiennecollin.plugins.lsp.servers.clangd")(capabilities, on_attach)
			end,
			["tailwindcss"] = function()
				require("etiennecollin.plugins.lsp.servers.tailwindcss")(capabilities, on_attach)
			end,
		})

		-----------------------------------------------------------------------
		-- Set diagnostic symbols
		-----------------------------------------------------------------------
		local signs = {
			Error = " ",
			Warn = " ",
			Hint = " ",
			Info = " ",
		}
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, {
				text = icon,
				texthl = hl,
				numhl = "",
			})
		end

		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			update_in_insert = true,
			underline = true,
			severity_sort = false,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
