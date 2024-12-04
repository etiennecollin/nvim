return {
	-- "tpope/vim-abolish",
	"abolish.nvim",
	dev = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local abolish = require("abolish")

		vim.keymap.set({ "n" }, "crs", abolish.snakecase)
		vim.keymap.set({ "n" }, "crc", abolish.camelcase)
		vim.keymap.set({ "n" }, "crm", abolish.mixedcase, { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "cru", abolish.uppercase, { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "cr-", abolish.dashcase, { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "cr.", abolish.dotcase, { noremap = true, silent = true })
	end,
}
