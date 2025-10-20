return {
	-- Seems fancier than I need. Will add this to the performance check and maybe look at why this is useful later on.
	-- Source: https://github.com/stevearc/oil.nvim?tab=readme-ov-file#installation
	"stevearc/oil.nvim",
	cmd = "Oil",
	keys = {
		{ "<leader>e", function() require("oil").open() end, desc = "Open file explorer" },
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		-- Disable netrw early so it never hijacks directory buffers
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- If Neovim was started with exactly one directory argument, open Oil
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				-- count of "file" args (ignores -c, -S etc.)
				if vim.fn.argc(-1) ~= 1 then
					return
				end
				local arg = vim.fn.argv(0)
				if not arg or arg == "" then
					return
				end
				local uv = vim.uv or vim.loop
				local stat = uv.fs_stat(arg)
				if stat and stat.type == "directory" then
					-- Schedule to avoid race conditions with startup
					vim.schedule(function()
						vim.cmd(string.format("Oil %s", vim.fn.fnameescape(arg)))
					end)
				end
			end,
		})
	end,
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
