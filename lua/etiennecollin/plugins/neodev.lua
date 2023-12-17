return {
	"folke/neodev.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "hrsh7th/nvim-cmp" },
	opts = {
		library = {
			plugins = { "nvim-dap-ui" },
			types = true,
		},
	},
}
