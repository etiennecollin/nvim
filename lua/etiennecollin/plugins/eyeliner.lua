return {
	"jinh0/eyeliner.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		highlight_on_key = true, -- show highlights only after keypress
		dim = true, -- dim all other characters if set to true
	},
}
