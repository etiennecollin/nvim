return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = {
		-- "nvim-neo-tree/neo-tree.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("a", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("SPC e", "  > File explorer", "<cmd>Neotree toggle<CR>"),
			dashboard.button("SPC sf", "󰱼  > Search File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC sg", "  > Search Global Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

		-- local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
		-- vim.api.nvim_create_autocmd("BufEnter", {
		--     group = alpha_on_empty,
		--     callback = function(event)
		--         local buffer_name = vim.api.nvim_buf_get_name(event.buf)
		--         local buffer_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
		--         local buffer_lines = vim.api.nvim_buf_get_lines(event.buf, 0, -1, false)
		--
		--         local count = 0
		--         for _ in pairs(buffer_lines) do
		--             count = count + 1
		--         end
		--
		--         local fallback_on_empty = buffer_name == "" and buffer_ft == "" and count == 1 and buffer_lines[1] == ""
		--
		--         if fallback_on_empty then
		--             require("etiennecollin.utils").print_table(buffer_lines)
		--             print(count)
		--             vim.cmd("Alpha")
		--         end
		--     end,
		-- })
	end,
}
