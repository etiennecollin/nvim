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
			ensure_installed = require("etiennecollin.utils").ensure_installed_lsps,
			automatic_installation = true,
		})

		-----------------------------------------------------------------------
		-- Setup AutoCommands
		-----------------------------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("etiennecollin-lsp-attach", { clear = true }),
			desc = "LSP Attach",
			callback = function(event)
				-- -- The following two autocommands are used to highlight references of the
				-- -- word under your cursor when your cursor rests there for a little while.
				-- -- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				-- if client and client.server_capabilities.documentHighlightProvider then
				-- 	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				-- 		buffer = event.buf,
				-- 		callback = vim.lsp.buf.document_highlight,
				-- 	})
				--
				-- 	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				-- 		buffer = event.buf,
				-- 		callback = vim.lsp.buf.clear_references,
				-- 	})
				-- end

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, { buffer = event.buf, desc = "LSP: Inlay Hints" })
				end
			end,
		})

		-----------------------------------------------------------------------
		-- Setup handlers
		-----------------------------------------------------------------------
		local capabilities = require("etiennecollin.utils").get_lsp_capabilities()
		local on_attach = require("etiennecollin.core.remaps_plugin").lsp

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

		-----------------------------------------------------------------------
		-- Set diagnostic symbols
		-----------------------------------------------------------------------
		local signs = {
			Error = " ",
			Warn = " ",
			Hint = "󰌵 ",
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
			virtual_text = {
				severity = { min = vim.diagnostic.severity.WARN },
			},
			signs = true,
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,
}
