return {
	"andymass/vim-matchup",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
	end,
}
