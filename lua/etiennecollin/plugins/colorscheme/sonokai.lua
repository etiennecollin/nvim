return {
	"sainnhe/sonokai",
	name = "sonokai",
	lazy = true,
	priority = 1000,
	init = function()
		vim.g.sonokai_diagnostic_line_highlight = 1
		vim.g.sonokai_diagnostic_text_highlight = 1
		vim.g.sonokai_diagnostic_virtual_text = "highlighted"
		vim.g.sonokai_enable_italic = 1
		vim.g.sonokai_inlay_hints_background = "dimmed"
		vim.g.sonokai_style = "shusia" --  Available values: 'default', 'atlantis', 'andromeda', 'shusia', 'maia','espresso'
		vim.g.sonokai_transparent_background = 0
	end,
}
