return {
	"nvim-pack/nvim-spectre",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = "Spectre",
	config = function()
		require("etiennecollin.core.remaps_plugin").spectre()
	end,
}
