return {
	"kaarmu/typst.vim",
	ft = "typst",
	config = function()
		vim.g.typst_pdf_viewer = "skim"
		vim.g.typst_conceal = 0
		vim.g.typst_auto_open_quickfix = 0
		require("etiennecollin.core.remaps_plugin").typst()
	end,
}
