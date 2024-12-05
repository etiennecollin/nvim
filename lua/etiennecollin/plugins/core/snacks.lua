return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = {
			enabled = true,
			notify = true,
			size = 1.5 * 1024 * 1024, -- 1.5MB
		},
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = " ", key = "sf", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "a", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "sg",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "so",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = " ",
						key = "m",
						desc = "Mason",
						action = ":Mason",
					},
					{
						icon = "󰒲 ",
						key = "l",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{
						icon = "󰖟 ",
						key = "b",
						desc = "Browse Repo",
						action = ":lua Snacks.gitbrowse()",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			},
			sections = {
				{
					section = "terminal",
					cmd = "chafa ~/Pictures/wallpapers/a_moonlit_night_at_sea.jpg --format symbols --symbols vhalf --size 60x17 --stretch",
					height = 17,
					padding = 1,
				},
				{
					pane = 2,
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		words = {
			enabled = true,
			debounce = 100,
		},
		styles = {
			notification = {
				wo = { wrap = true }, -- Wrap notifications
			},
		},
	},
	init = function()
		require("etiennecollin.core.remaps_plugin").snacks()
	end,
}
