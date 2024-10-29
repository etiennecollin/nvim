return {
	"3rd/image.nvim",
	ft = { "markdown", "vimwiki", "html", "typst" },
	dependencies = {
		"leafo/magick",
	},
	opts = {
		backend = "kitty",
		integrations = {
			typst = {
				enabled = true,
				download_remote_images = true,
				only_render_image_at_cursor = true,
			},
			html = {
				enabled = true,
				download_remote_images = true,
				only_render_image_at_cursor = true,
			},
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = true,
				filetypes = { "markdown", "vimwiki" },
			},
		},
		max_width = nil,
		max_height = nil,
		max_width_window_percentage = 50,
		max_height_window_percentage = 50,
		-- auto show/hide images when the editor gains/looses focus
		editor_only_render_when_focused = false,
		-- toggles images when windows are overlapped
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		-- auto show/hide images in the correct Tmux window (needs visual-activity off)
		tmux_show_only_in_active_window = false,
	},
}
