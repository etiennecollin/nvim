return {
	"folke/tokyonight.nvim",
	name = "tokyonight",
	lazy = false,
	priority = 1000,
	config = function()
		require("etiennecollin.utils").set_colorscheme()
	end,
}
