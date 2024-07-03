return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
		"folke/noice.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("noice")

		telescope.setup({
			defaults = require("telescope.themes").get_ivy({
				path_display = { "truncate" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<esc>"] = actions.close,
						["<CR>"] = actions.select_default + actions.center,
					},
				},
			}),
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = actions.delete_buffer,
						},
					},
				},
				colorscheme = {
					enable_preview = true,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_ivy(),
				},
			},
		})

		require("etiennecollin.core.remaps_plugin").telescope()
	end,
}
