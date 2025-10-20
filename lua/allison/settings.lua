vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = true

-- This was crazy? some weird helix nonsense.
-- vim.opt.whichwrap = "b,s,h,l"

-- TODO: wrapmargin is not working, fix it!
-- NVM, seems fine now? Remove this TODO once you confirm forsure it's working well?
vim.opt.wrapmargin = 25
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.o.termguicolors = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.opt.swapfile = false
vim.opt.updatetime = 300
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true


-- Add Zine file type associations
vim.filetype.add({
	extension = {
		smd = 'supermd',
		shtml = 'superhtml',
		ziggy = 'ziggy',
		['ziggy-schema'] = 'ziggy_schema',
	},
})

-- Expandtab exceptions for languages that require tabs
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "make", "go" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	group = vim.api.nvim_create_augroup("TabSettings", { clear = true }),
})
