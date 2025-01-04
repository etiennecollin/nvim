return {
	"navarasu/onedark.nvim",
	name = "onedark",
	lazy = false,
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "warmer",
		})
		require("etiennecollin.utils").set_colorscheme()
	end,
}
