return {
	"danymat/neogen",
	cmd = "Neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	opts = {
		enabled = true,
		input_after_comment = true,
	},
	init = function()
		require("etiennecollin.core.mappings.plugin").neogen()
	end,
}
