return {
	"saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	tag = "stable",
	dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls.nvim" },
	opts = {
		null_ls = {
			enabled = true,
			name = "crates.nvim",
		},
	},
}
