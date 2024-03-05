return {
	"benlubas/molten-nvim",
	ft = "quarto",
	dependencies = "3rd/image.nvim",
	build = ":UpdateRemotePlugins",
	init = function()
		vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_output_win_max_height = 20
		vim.g.molten_auto_open_output = false
	end,
}
