return {
	"jmbuhr/otter.nvim",
	ft = "quarto",
	dependencies = { "neovim/nvim-lspconfig" },
	opts = {
		buffers = {
			set_filetype = true,
		},
		handle_leading_whitespace = true,
	},
}
