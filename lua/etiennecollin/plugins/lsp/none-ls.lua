return {
	"nvimtools/none-ls.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "jay-babu/mason-null-ls.nvim", dependencies = "williamboman/mason.nvim" },
	},
	config = function()
		-----------------------------------------------------------------------
		-- Install linters and formatters with mason
		-----------------------------------------------------------------------
		require("mason-null-ls").setup({
			ensure_installed = require("etiennecollin.utils").ensure_installed_linter_formatter,
			automatic_installation = true,
			handlers = {},
		})

		-----------------------------------------------------------------------
		-- Set lsp formatter client to null-ls
		-----------------------------------------------------------------------
		local lsp_formatting = function(bufnr)
			-- vim.lsp.buf.format({
			--     filter = function(client)
			--         return client.name == "null-ls"
			--     end,
			--     bufnr = bufnr,
			-- })
			vim.lsp.buf.format()
		end

		-----------------------------------------------------------------------
		-- Formatting on save and setup null-ls
		-----------------------------------------------------------------------
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.clang_format.with({
					disabled_filetypes = { "java" },
				}),
				null_ls.builtins.formatting.google_java_format.with({
					extra_args = { "--aosp" },
				}),
				null_ls.builtins.formatting.black.with({
					extra_args = { "--line-length=120" },
				}),
				null_ls.builtins.formatting.clang_format.with({
					extra_args = { "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}" },
				}),
				null_ls.builtins.formatting.typstfmt,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({
						group = augroup,
						buffer = bufnr,
					})
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							lsp_formatting(bufnr)
						end,
					})
				end
			end,
		})
	end,
}
