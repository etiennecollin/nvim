return {
	"danymat/neogen",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		require("neogen").setup({
			enabled = true,
			input_after_comment = true,
		})
		require("etiennecollin.core.mappings.plugin").neogen()
	end,
}
