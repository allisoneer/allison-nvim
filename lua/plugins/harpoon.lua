return {
	-- Quick access to frequently used files
	-- Solves "buffer switching doesn't scale" problem
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: Add file" },
		{ "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Quick menu" },
		{ "<leader>ha", function() require("harpoon"):list():select(1) end, desc = "Harpoon: File 1" },
		{ "<leader>hs", function() require("harpoon"):list():select(2) end, desc = "Harpoon: File 2" },
		{ "<leader>hd", function() require("harpoon"):list():select(3) end, desc = "Harpoon: File 3" },
		{ "<leader>hf", function() require("harpoon"):list():select(4) end, desc = "Harpoon: File 4" },
	},
	config = function()
		require("harpoon").setup({})
	end,
}
