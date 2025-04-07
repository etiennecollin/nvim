return {
	"laytan/cloak.nvim",
	ft = { "asc", "sh", "secret" },
	opts = {
		enabled = true,
		cloak_character = "*",
		cloak_length = 8,
		-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
		highlight_group = "Comment",
		patterns = {
			{
				file_pattern = {
					"*.asc",
					"*.env",
					"*.secret",
				},
				cloak_pattern = { "=.+", ":.+" },
			},
		},
	},
}
