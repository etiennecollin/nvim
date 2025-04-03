return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "nvim-treesitter/nvim-treesitter-context", "andymass/vim-matchup" },
	opts = {
		ensure_installed = require("etiennecollin.config").ensure_installed_treesitter,
		sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
		auto_install = true, -- Automatically install missing parsers when entering buffer
		highlight = {
			enable = true,
			disable = { "latex" },
			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
		matchup = { -- For vim-matchup
			enable = true,
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
		require("treesitter-context").setup({
			separator = "-",
		})
	end,
}
