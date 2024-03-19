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
				zsh = { "shfmt" },
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
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_fallback = true }
			end,
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

		-- Create commands to enable/disable autoformat-on-save
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({ lsp_fallback = true, async = false })
		end, { desc = "Format buffer" })
	end,
}
