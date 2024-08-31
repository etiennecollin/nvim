return {
	"HakonHarnes/img-clip.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		default = {
			url_encode_path = true,
			relative_to_current_file = true,
		},
		filetypes = {
			quarto = {
				template = "![$CURSOR]($FILE_PATH)",
			},
		},
	},
	keys = {
		{ "<leader>P", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
	},
}
