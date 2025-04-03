return {
	"nat-418/boole.nvim",
	cmd = "Boole",
	init = function()
		require("etiennecollin.core.mappings.plugin").boole()
	end,
	opts = {
		mappings = {
			increment = nil,
			decrement = nil,
		},
		-- User defined loops
		-- additions = {
		-- 	{ "Foo", "Bar" },
		-- 	{ "tic", "tac", "toe" },
		-- },
		allow_caps_additions = {
			{ "enable", "disable" },
			-- enable → disable
			-- Enable → Disable
			-- ENABLE → DISABLE
		},
	},
}
