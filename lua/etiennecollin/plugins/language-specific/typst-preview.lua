return {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	build = function()
		require("typst-preview").update()
	end,
	opts = {
		get_root = function()
			return os.getenv("HOME")
		end,
	},
}
