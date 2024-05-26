return {
	"3rd/image.nvim",
	enabled = false,
	init = function()
		package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
		package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
	end,
	opts = {
		backend = "kitty",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "markdown", "vimwiki", "typst" },
			},
		},
		max_width = 100,
		max_height = 20,
		max_height_window_percentage = math.huge, -- this is necessary for a good experience
		max_width_window_percentage = math.huge,
		-- auto show/hide images when the editor gains/looses focus
		editor_only_render_when_focused = false,
		-- toggles images when windows are overlapped
		window_overlap_clear_enabled = false,
		-- auto show/hide images in the correct Tmux window (needs visual-activity off)
		tmux_show_only_in_active_window = true,
	},
}
