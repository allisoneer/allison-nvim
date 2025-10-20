return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	keys = {
		{ "<leader>dd", function() require("trouble").toggle() end, desc = "Toggle Trouble" },
		{ "<leader>dg", function() require("trouble").toggle("git_signs") end, desc = "Git hunks (Trouble)" },
	},
	opts = {},
}
