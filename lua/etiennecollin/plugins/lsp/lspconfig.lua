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
			ensure_installed = require("etiennecollin.utils").ensure_installed_lsp,
			automatic_installation = true,
		})

		-----------------------------------------------------------------------
		-- Setup AutoCommands
		-----------------------------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("etiennecollin-lsp-attach", { clear = true }),
			callback = function(event)
				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and (
						client.server_capabilities.documentHighlightProvider
						or client.server_capabilities.document_highlight
					)
				then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
					end, { buffer = event.buf, desc = "LSP: Inlay Hints" })
				end
			end,
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
			["typst_lsp"] = function()
				require("etiennecollin.plugins.lsp.servers.typst_lsp")(capabilities, on_attach)
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

		-----------------------------------------------------------------------
		-- Set Quarto resources
		-----------------------------------------------------------------------
		local function get_quarto_resource_path()
			local function strsplit(s, delimiter)
				local result = {}
				for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
					table.insert(result, match)
				end
				return result
			end

			local f = assert(io.popen("quarto --paths", "r"))
			local s = assert(f:read("*a"))
			f:close()
			return strsplit(s, "\n")[2]
		end

		local lua_library_files = vim.api.nvim_get_runtime_file("", true)
		local lua_plugin_paths = {}
		local resource_path = get_quarto_resource_path()
		if resource_path == nil then
			vim.notify_once("quarto not found, lua library files not loaded")
		else
			table.insert(lua_library_files, resource_path .. "/lua-types")
			table.insert(lua_plugin_paths, resource_path .. "/lua-plugin/plugin.lua")
		end
	end,
}
