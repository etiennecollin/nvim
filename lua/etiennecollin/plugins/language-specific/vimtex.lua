return {
	"lervag/vimtex",
	ft = "tex",
	config = function()
		vim.g.tex_flavor = "latex"

		-- Viewer
		vim.g.vimtex_view_method = "sioyek"

		vim.g.vimtex_log_ignore = {
			"Underfull",
			"Overfull",
			"specifier changed to",
			"Token not allowed in a PDF string",
		}
		vim.g.vimtex_quickfix_mode = 0
		vim.opt.conceallevel = 0
		-- vim.g.tex_conceal = "abdmg"
	end,
}
