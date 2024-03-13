return {
	"michaelrommel/nvim-silicon",
	cmd = "Silicon",
	init = function()
		require("etiennecollin.core.remaps_plugin").silicon()
	end,
	opts = {},
	config = function()
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
		require("silicon").setup({
			theme = "Monokai Extended",
			font = "JetBrainsMono Nerd Font=34",
			to_clipboard = true,
			window_title = function()
				return filename
			end,
			output = function()
				return "./" .. os.date("!%Y_%m_%dT%H_%M_%S") .. filename .. "_code.png"
			end,
		})
	end,
}
