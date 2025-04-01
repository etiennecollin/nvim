return {
	"saghen/blink.cmp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"rafamadriz/friendly-snippets",
		"folke/lazydev.nvim",
		"jmbuhr/cmp-pandoc-references",
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
		sources = {
			default = { "copilot", "lsp", "lazydev", "path", "snippets", "buffer" },
			per_filetype = {
				typst = { "references", "copilot", "lsp", "lazydev", "path", "snippets", "buffer" },
			},
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
				references = {
					name = "pandoc_references",
					module = "cmp-pandoc-references.blink",
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
