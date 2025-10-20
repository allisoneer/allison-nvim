return {
	-- Seems like the best option for fuzzy finding. Can run :checkhealth telescope to see if it's healthy.
	-- TODO: Go through pickers and find what I actually want to use.
	-- Source: https://github.com/nvim-telescope/telescope.nvim
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope buffers<cr>", desc = "Find Open Files" },
		{ "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Find in Files" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").setup({})
		-- require("telescope").load_extension("ui-select")
	end,
}
