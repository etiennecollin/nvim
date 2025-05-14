return {
	"Bekaboo/dropbar.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("etiennecollin.core.mappings.plugin").dropbar()
	end,
}
