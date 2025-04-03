return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local whichkey = require("which-key")
		whichkey.setup({
			preset = "classic",
			icons = { mappings = false },
		})
		whichkey.add({
			mode = { "n" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>B", group = "Tab" },
			{ "<leader>D", group = "Debug" },
			{ "<leader>g", group = "Git" },
			{ "<leader>n", group = "New" },
			{ "<leader>r", group = "LSP" },
			{ "<leader>s", group = "Search" },
			{ "<leader>t", group = "Toggle" },
			{ "<leader>tt", group = "Specific Terminal" },
			{ "<leader>ts", group = "Slime" },
			{ "<leader>x", group = "Trouble" },
			{ "<leader>X", group = "Utilities" },
			{ "<leader>z", group = "Lazy/Mason" },
		})
		whichkey.add({
			mode = { "v" },
			{ "<leader>g", group = "Git" },
			{ "<leader>s", group = "Search" },
			{ "<leader>X", group = "Utilities" },
		})

		-- Update keybinds when filetype changes
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("etiennecollin-filetype-keybinds", { clear = true }),
			desc = "Set keybinds when filetype changes",
			callback = require("etiennecollin.core.mappings.plugin").language_specific,
		})

		-- Run the function manually for the first time
		-- This is necessary to run when opening file with `nvim file.ext`
		require("etiennecollin.core.mappings.plugin").language_specific()
	end,
}
