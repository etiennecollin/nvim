return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		render = "background", -- "background"|"foreground"|"virtual"
		enable_hex = true,
		enable_short_hex = true,
		enable_rgb = true,
		enable_hsl = true,
		enable_var_usage = true,
		enable_named_colors = true,
		enable_tailwind = true,
	},
}
