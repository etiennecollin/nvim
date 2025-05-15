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
			{ "<leader>g", group = "Git" },
			{ "<leader>N", group = "New" },
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
	end,
}
