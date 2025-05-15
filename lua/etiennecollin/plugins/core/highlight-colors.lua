return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		render = "background", -- "background"|"foreground"|"virtual"
		virtual_symbol = "■",
		virtual_symbol_position = "inline", -- "inline"|"eol"|"eow"
		enable_ansi = true, -- \033[0;34m
		enable_hex = true, -- #ABCDEF
		enable_short_hex = true, -- #ABC
		enable_rgb = true, -- rgb(169, 42, 69)
		enable_hsl = true, -- hsl(169, 42%, 69%)
		enable_hsl_without_function = true, -- `--foreground: 42 69% 69%;'
		enable_var_usage = true, -- CSS vars: '--testing-color: #ABCDEF; var(--testing-color)'
		enable_named_colors = true, -- CSS colors: `color: orchid`
		enable_tailwind = true, -- bg-sky-700
	},
}
