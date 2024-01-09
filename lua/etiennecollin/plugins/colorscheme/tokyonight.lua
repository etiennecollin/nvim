return {
	"folke/tokyonight.nvim",
	name = "tokyonight",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night",
		day_brightness = 0.4, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		dim_inactive = false, -- dims inactive windows
	},
}
