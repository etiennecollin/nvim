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
			"dapui-terminal",
			"dapui_breakpoints",
			"dapui_console",
			"dapui_scopes",
			"dapui_stacks",
			"dapui_watches",
			"diff",
			"neo-tree",
			"snacks_picker_list",
			"snacks_terminal",
			"spectre_panel",
			"terminal",
			"toggleterm",
			"TelescopePrompt",
			"Trouble",
			"undotree",
			"", -- Hover popups such as Treesitter syntax investigation popup, lsp popups...
		}

		local augroup = vim.api.nvim_create_augroup("plugin-focus-disable", { clear = true })

		vim.api.nvim_create_autocmd("WinEnter", {
			group = augroup,
			desc = "Disable focus autoresize for BufType",
			callback = function()
				if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
					vim.b.focus_disable = true
				end
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			desc = "Disable focus autoresize for FileType",
			callback = function()
				if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
					vim.b.focus_disable = true
				end
			end,
		})
	end,
}
