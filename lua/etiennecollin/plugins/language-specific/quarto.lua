return {
	"quarto-dev/quarto-nvim",
	opts = {
		lspFeatures = {
			languages = { "r", "python", "julia", "bash", "html", "lua" },
		},
	},
	ft = "quarto",
	dependencies = { "jmbuhr/otter.nvim" },
}
