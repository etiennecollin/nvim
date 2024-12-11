return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
	init = function()
		require("etiennecollin.core.remaps_plugin").toggleterm()
	end,
	config = true,
}
