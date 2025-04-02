return {
	"MagicDuck/grug-far.nvim",
	opts = {},
	config = function(_, opts)
		require("grug-far").setup(opts)
		require("etiennecollin.core.remaps_plugin").grug_far()
	end,
}
