return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,
	config = function()
		require("etiennecollin.core.remaps_plugin").ufo_remaps()

		local ufo = require("ufo")
		ufo.setup()
	end,
}
