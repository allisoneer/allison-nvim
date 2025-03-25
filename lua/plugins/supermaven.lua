return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			ignore_filetypes = {},
			color = {
				suggestion_color = "#7c6f64", -- Using grey0 from my gruvbox theme
				cterm = 244,
			},
			log_level = "info",
			disable_inline_completion = false,
		})

		-- Set the completion item highlight to use your theme's green color

		vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#a9b665" })
	end,
}
