return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"rafamadriz/friendly-snippets", -- Collection of useful snippets
		"mireq/luasnip-snippets", -- Collection of useful snippets
	},
	build = "make install_jsregexp",
	config = function()
		local luasnip = require("luasnip")

		-- Setup luasnip_snippets
		require("luasnip_snippets.common.snip_utils").setup()

		-- Setup luasnip
		luasnip.setup({
			-- Required to automatically include base snippets, like "c" snippets for "cpp"
			load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func,
			ft_func = require("luasnip_snippets.common.snip_utils").ft_func,
			-- Enable autotriggered snippets
			enable_autosnippets = true,
			-- Auto update fields sharing same argument
			update_events = "TextChanged,TextChangedI",
		})

		-- Load snippets
		require("luasnip.loaders.from_lua").lazy_load({
			paths = { "~/.config/nvim/lua/etiennecollin/snippets" },
		})
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
