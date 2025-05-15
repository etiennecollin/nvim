return {
	"saghen/blink.cmp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"rafamadriz/friendly-snippets",
		"folke/lazydev.nvim",
		"jmbuhr/cmp-pandoc-references",
		{ "fang2hou/blink-copilot", dependencies = "zbirenbaum/copilot.lua" },
		"brenoprata10/nvim-highlight-colors",
	},
	version = "1.*",
	opts = {
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 0,
			},
			ghost_text = {
				enabled = false,
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
					-- Use nvim-highlight-colors to show colors in the menu
					components = {
						kind_icon = {
							text = function(ctx)
								-- Default kind icon
								local icon = ctx.kind_icon
								-- If LSP source, check for color derived from documentation
								if ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr ~= "" then
										icon = color_item.abbr
									end
								end
								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								-- Default highlight group
								local highlight = "BlinkCmpKind" .. ctx.kind
								-- If LSP source, check for color derived from documentation
								if ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr_hl_group then
										highlight = color_item.abbr_hl_group
									end
								end
								return highlight
							end,
						},
					},
				},
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
			default = { "copilot", "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				typst = { "references", "copilot", "lsp", "path", "snippets", "buffer" },
				markdown = { "references", "copilot", "lsp", "path", "snippets", "buffer" },
				lua = { "lazydev", "copilot", "lsp", "path", "snippets", "buffer" },
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
