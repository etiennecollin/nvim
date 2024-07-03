return {
	"nvim-focus/focus.nvim",
	version = "*",
	config = function()
		local focus = require("focus")
		focus.setup({
			ui = {
				cursorline = false,
				signcolumn = false,
				winhighlight = false,
			},
			autoresize = {
				enable = true,
			},
			split = {
				bufnew = true, -- Create blank buffer for new split windows
			},
		})

		local ignore_buftypes = { "nofile", "prompt", "popup" }

		local ignore_filetypes = {
			"dap-repl",
			"dapui_console",
			"dapui_watches",
			"dapui_stacks",
			"dapui_breakpoints",
			"dapui_scopes",
			"dapui-terminal",
			"terminal",
			"toggleterm",
			"neo-tree",
			"Trouble",
			"TelescopePrompt",
			"spectre_panel",
			"", -- Hover popups such as Treesitter syntax investigation popup, lsp popups...
		}

		local augroup = vim.api.nvim_create_augroup("plugin-focus-disable", { clear = true })

		vim.api.nvim_create_autocmd("WinEnter", {
			group = augroup,
			desc = "Disable focus autoresize for BufType",
			callback = function(_)
				if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
					vim.b.focus_disable = true
				end
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			desc = "Disable focus autoresize for FileType",
			callback = function(_)
				if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
					vim.b.focus_disable = true
				end
			end,
		})
	end,
}
