return {
	"saghen/blink.cmp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"rafamadriz/friendly-snippets",
		"folke/lazydev.nvim",
		{ "fang2hou/blink-copilot", dependencies = "zbirenbaum/copilot.lua" },
	},
	version = "1.*",
	opts = {
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 0,
			},
			ghost_text = {
				enabled = true,
			},
			menu = {
				draw = { treesitter = { "lsp" } },
			},
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
		keymap = { preset = "super-tab" },
		signature = {
			enabled = true,
			window = {
				show_documentation = false,
			},
		},
		snippets = { preset = "luasnip" },
		sources = {
			default = { "copilot", "lsp", "snippets", "lazydev", "path", "snippets", "buffer" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
