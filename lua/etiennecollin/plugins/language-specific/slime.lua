return {
	"jpalardy/vim-slime",
	ft = { "markdown", "typst", "python" },
	init = function()
		vim.g.slime_cell_delimiter = "^\\s*```"

		-- Use neovim terminal for slime
		vim.g.slime_target = "neovim"
		vim.g.slime_dont_ask_default = 0
		vim.g.slime_bracketed_paste = 1
		vim.g.slime_python_ipython = 0

		-- Do not use default mappings
		vim.g.slime_no_mappings = 1

		require("etiennecollin.core.remaps_plugin").slime()
	end,
}
