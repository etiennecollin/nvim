return {
	"nvim-lualine/lualine.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local custom_theme = require("lualine.themes.auto")
		local utils = require("etiennecollin.utils")

		local keys = { "inactive", "visual", "replace", "normal", "insert", "command" }
		for _, key in ipairs(keys) do
			utils.set_key_recursive(custom_theme, key .. ".c.bg", nil)
		end

		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		require("lualine").setup({
			options = {
				theme = custom_theme,
				disabled_filetypes = {
					-- Filetypes to disable lualine for.
					"TelescopePrompt",
					"Trouble",
					"dap-repl",
					"dapui-terminal",
					"dapui_breakpoints",
					"dapui_console",
					"dapui_scopes",
					"dapui_stacks",
					"dapui_watches",
					"diff",
					"neo-tree",
					"spectre_panel",
					"terminal",
					"toggleterm",
					"undotree",
					"", -- Hover popups such as Treesitter syntax investigation popup, lsp popups...
					statusline = {}, -- only ignores the ft for statusline.
					winbar = {}, -- only ignores the ft for winbar.
				},
			},
			sections = {
				lualine_c = {
					{
						"filename",
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						path = 1, -- 0: Just the filename
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory

						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						-- for other components. (terrible name, any suggestions?)
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[ ]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
