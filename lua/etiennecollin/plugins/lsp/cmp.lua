return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-path", -- Source for completion of paths
		"hrsh7th/cmp-buffer", -- Source for completion of words in buffers
		"hrsh7th/cmp-cmdline", -- Source for commandline completion
		"hrsh7th/cmp-nvim-lua", -- Source for completion of Neovim's Lua API
		"hrsh7th/cmp-nvim-lsp-signature-help", -- Source for function signature
		"hrsh7th/cmp-emoji", -- Source for emojis
		{ "zbirenbaum/copilot-cmp", dependencies = "zbirenbaum/copilot.lua", config = true }, -- Source for copilot
		{ "saadparwaiz1/cmp_luasnip", dependencies = "L3MON4D3/LuaSnip" }, -- Source for completion of LuaSnip snippets
		"jmbuhr/cmp-pandoc-references", -- Source for pandoc refs
		"onsails/lspkind.nvim", -- Pictograms in completion menu
	},
	config = function()
		local luasnip = require("luasnip")
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		-- Set color for copilot suggestions
		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#aa7de8" })

		-----------------------------------------------------------------------
		-- Aux function
		-----------------------------------------------------------------------
		local has_words_before = function()
			--     unpack = unpack or table.unpack
			if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
				return false
			end
			local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
		end

		-----------------------------------------------------------------------
		-- Setup nvim-cmp
		-----------------------------------------------------------------------
		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect,noinsert",
			},

			-- Configure how nvim-cmp interacts with luasnip
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			sources = cmp.config.sources({
				{ name = "copilot" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "pandoc_references" },
				{ name = "buffer" },
				{ name = "nvim_lua" },
				{ name = "emoji" },
			}),

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			-- Set formatting of completion menu
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
					symbol_map = {
						Copilot = "",
					},
				}),
			},

			mapping = cmp.mapping.preset.insert({
				["<cr>"] = nil,
				["<c-e>"] = cmp.mapping.abort(),
				["<c-u>"] = cmp.mapping.scroll_docs(-4),
				["<c-d>"] = cmp.mapping.scroll_docs(4),
				["<c-p>"] = cmp.mapping.select_prev_item(),
				["<c-n>"] = cmp.mapping.select_next_item(),
				["<tab>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_locally_jumpable() then
						-- Replace the expand_or_jumpable() with expand_or_locally_jumpable()
						-- to only jump inside the snippet region
						luasnip.expand_or_jump()
					elseif cmp.visible() then
						cmp.confirm({
							select = true,
						})
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					elseif cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
		})

		-- Add completion to search mode
		cmp.setup.cmdline("/", {
			sources = {
				{ name = "buffer" },
			},
		})

		-- Add completion to command mode
		cmp.setup.cmdline(":", {
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		-- Enable completion in Cargo.toml files for crates
		vim.api.nvim_create_autocmd("BufRead", {
			group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
			pattern = "Cargo.toml",
			callback = function()
				cmp.setup.buffer({ sources = { { name = "crates" } } })
			end,
		})
	end,
}
