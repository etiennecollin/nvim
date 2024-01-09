return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = true,
}
