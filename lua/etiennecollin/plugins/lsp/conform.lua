return {
	"stevearc/conform.nvim",
	enabled = not require("etiennecollin.plugins.lsp.none-ls").enabled,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "zapling/mason-conform.nvim", dependencies = "williamboman/mason.nvim" },
	cmd = { "ConformInfo" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				java = { "google-java-format" },
				typst = { "typstfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
			formatters = {
				black = {
					prepend_args = { "--line-length=120" },
				},
				clang_format = {
					prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}" },
				},
				google_java_format = {
					prepend_args = { "--aosp" },
				},
			},
		})

		-- Install formatters with mason
		require("mason-conform").setup()

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({ lsp_fallback = true, async = false })
		end, { desc = "Format buffer" })
	end,
}
