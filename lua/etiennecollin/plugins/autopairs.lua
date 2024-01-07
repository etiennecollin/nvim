return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local npairs = require("nvim-autopairs")
		local rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		npairs.setup({
			check_ts = true, -- Enable treesitter
		})

		npairs.add_rules({
			rule("$", "$", { "tex", "latex" })
				-- move right when repeating $
				:with_move(cond.done()),
		})

		-- Make autopairs and completion work together
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
