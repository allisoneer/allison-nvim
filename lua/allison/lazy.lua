local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
	-- Check git is available
	if vim.fn.executable("git") == 0 then
		vim.notify(
			"git not found! Please install git to bootstrap lazy.nvim",
			vim.log.levels.ERROR
		)
		return
	end

	-- Clone lazy.nvim
	vim.notify("Bootstrapping lazy.nvim...", vim.log.levels.INFO)
	local result = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})

	-- Check if clone succeeded
	if vim.v.shell_error ~= 0 then
		vim.notify(
			"Failed to clone lazy.nvim:\n" .. result,
			vim.log.levels.ERROR
		)
		return
	end

	vim.notify("lazy.nvim bootstrapped successfully!", vim.log.levels.INFO)
end

vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim with error handling
local ok, lazy = pcall(require, "lazy")
if not ok then
	vim.notify(
		"Failed to load lazy.nvim. Please check installation.",
		vim.log.levels.ERROR
	)
	return
end

lazy.setup("plugins", {
	change_detection = {
		notify = false,
	},
	rocks = {
		hererocks = true,
	},
})
