return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	keys = {
		{ "<leader>dd", function() require("trouble").toggle() end, desc = "Toggle Trouble" },
	},
	opts = {},
}
