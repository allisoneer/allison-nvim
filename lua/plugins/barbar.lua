return {
	"romgrk/barbar.nvim",
	event = "VeryLazy",  -- Lazy load after startup
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	init = function() vim.g.barbar_auto_setup = true end,
	opts = {},
	version = "^1.0.0",
}
