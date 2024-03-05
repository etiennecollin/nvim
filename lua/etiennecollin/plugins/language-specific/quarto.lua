return {
	"quarto-dev/quarto-nvim",
	ft = "quarto",
	dependencies = { "jmbuhr/otter.nvim" },
	opts = {
		lspFeatures = {
			languages = { "r", "python", "julia", "bash", "html", "lua" },
			diagnostics = {
				triggers = { "BufWritePost", "BufEnter" },
			},
		},
		codeRunner = {
			enabled = true,
			default_method = "molten",
		},
		keymap = {
			-- set whole section or individual keys to `false` to disable
			hover = "K",
			definition = "gd",
			type_definition = "gD",
			rename = "<leader>rn",
			format = "<leader>f",
			references = "gr",
			document_symbols = "gS",
		},
	},
}
