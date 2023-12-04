return {
	"sainnhe/sonokai",
	name = "sonokai",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.sonokai_style = "andromeda" --  Available values: 'default', 'atlantis', 'andromeda', 'shusia', 'maia','espresso'
		vim.g.sonokai_enable_italic = 1
		vim.g.sonokai_transparent_background = 0
		vim.g.sonokai_diagnostic_text_highlight = 1
		vim.g.sonokai_diagnostic_line_highlight = 1
		vim.g.sonokai_diagnostic_virtual_text = "highlighted"
	end,
}
