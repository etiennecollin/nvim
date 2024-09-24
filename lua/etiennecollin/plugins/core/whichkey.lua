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
			{ "<leader>d", group = "Debug" },
			{ "<leader>h", group = "Hunk" },
			{ "<leader>n", group = "New" },
			{ "<leader>s", group = "Search" },
			{ "<leader>t", group = "Toggle" },
			{ "<leader>tT", group = "Specific Terminal" },
			{ "<leader>ts", group = "Slime" },
			{ "<leader>x", group = "Trouble" },
			{ "<leader>X", group = "Utilities" },
			{ "<leader>z", group = "Lazy/Mason" },
		})

		-- Update keybinds when filetype changes
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("etiennecollin-filetype-keybinds", { clear = true }),
			desc = "Set keybinds when filetype changes",
			callback = require("etiennecollin.core.remaps_plugin").language_specific,
		})

		-- Run the function manually for the first time
		-- This is necessary to run when opening file with `nvim file.ext`
		require("etiennecollin.core.remaps_plugin").language_specific()
	end,
}
