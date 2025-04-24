return {
	"3rd/image.nvim",
	opts = {
		backend = "kitty", -- Explicitly set Kitty backend
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				download_remote_images = false,
				only_render_image_at_cursor = false,
			},
		},
		window_overlap_clear_enabled = true, -- Clear images when windows overlap
		window_overlap_clear_ft_ignore = {}, -- Don't ignore any filetypes
	},
	rocks = { "magick" },                -- Install magick Lua rock
}
