return {
	-- Seems fancier than I need. Will add this to the performance check and maybe look at why this is useful later on.
	-- Source: https://github.com/stevearc/oil.nvim?tab=readme-ov-file#installation
	"stevearc/oil.nvim",
	cmd = "Oil",
	keys = {
		{ "<leader>e", function() require("oil").open() end, desc = "Open file explorer" },
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		oil.setup({
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
			},
		})
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			callback = function(opts)
				local buf = opts.buf
				local type = vim.bo[buf].ft

				if type == "oil" then
					vim.keymap.set({ "n", "v", "i" }, "<A-s>", function()
						oil.save({
							confirm = true,
						})
					end, {
						desc = "Save changes",
						buffer = buf,
					})
				end
			end,
		})
	end,
}
