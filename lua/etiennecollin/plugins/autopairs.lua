return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local npairs = require("nvim-autopairs")
		local rule = require("nvim-autopairs.rule")

		npairs.setup({
			check_ts = true, -- Enable treesitter
		})

		-- Add rules
		npairs.add_rule(rule("$", "$", "tex"))

		-- Make autopairs and completion work together
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
