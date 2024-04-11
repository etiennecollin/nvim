return {
	"michaelrommel/nvim-silicon",
	cmd = "Silicon",
	init = function()
		require("etiennecollin.core.remaps_plugin").silicon()
	end,
	opts = {},
	config = function()
		local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
		local fullname = vim.fn.fnamemodify(file, ":t")
		local basename = vim.fn.fnamemodify(file, ":r")
		local background_path = vim.fn.expand("~/github/dotfiles/wallpapers/ancient_bristlecone_pine_forest.jpg")

		require("silicon").setup({
			font = "JetBrainsMono Nerd Font=34",
			theme = "Monokai Extended",
			background = nil,
			background_image = background_path,
			shadow_color = "#161618",
			to_clipboard = true,
			line_offset = 0,
			window_title = function()
				return fullname
			end,
			output = function()
				return "./" .. basename .. os.date("!%Y%m%dT%H%M%S") .. "_code.png"
			end,
		})
	end,
}
