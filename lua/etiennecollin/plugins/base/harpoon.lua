return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("harpoon").setup()
		require("etiennecollin.core.remaps_plugin").harpoon()
	end,
}
