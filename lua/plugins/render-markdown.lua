return {
	'MeanderingProgrammer/render-markdown.nvim',
	ft = "markdown",
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		-- You already have nvim-web-devicons through barbar.nvim, so we'll use that
		'nvim-tree/nvim-web-devicons',
	},
	opts = {
		-- Basic default configuration, you can customize this later
		enabled = true,
		-- These are good defaults that work well with your gruvbox-material theme
		win_options = {
			conceallevel = {
				default = vim.o.conceallevel,
				rendered = 3,
			},
			concealcursor = {
				default = vim.o.concealcursor,
				rendered = '',
			},
		},
	},
}
