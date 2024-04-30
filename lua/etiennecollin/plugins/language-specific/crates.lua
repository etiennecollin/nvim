return {
	"saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	tag = "stable",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = true,
}
