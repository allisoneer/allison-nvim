vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function nmap(map, fn, desc)
	vim.keymap.set("n", map, fn, { desc = desc })
end

local function xmap(map, fn, desc)
	vim.keymap.set("x", map, fn, { desc = desc })
end

xmap("J", ":m '>+1<CR>gv=gv", "Move Selection down")
xmap("K", ":m '<-2<CR>gv=gv", "Move Selection up")

nmap("U", "<C-r>", "Redo")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
nmap("<leader>Y", [["+Y]], "Copy to clipboard until end of line")

vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from clipboard" })
nmap("<leader>P", [["+P]], "Paste from clipboard before cursor")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})


nmap("<leader>g", "<Cmd>BufferPick<CR>", "Pick a buffer!")

nmap("<leader>z", function()
	vim.system({ "/home/allison/.local/bin/zig-nvim-plugin" })
end, "Run zbr in zig-nvim-plugin directory")

nmap("<C-t>", "<Cmd>enew<CR>", "new buffer tab")
nmap("<C-q>", "<Cmd>BufferClose!<CR>", "Force close current buffer")

-- Copy current file path to clipboard
nmap("<leader>cp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied to clipboard: " .. path, vim.log.levels.INFO)
end, "Copy file path to clipboard")

-- Copy relative file path to clipboard (from initial Neovim startup directory)
nmap("<leader>cr", function()
	local initial_cwd = vim.g.initial_working_directory or vim.fn.getcwd()
	local full_path = vim.fn.expand("%:p")
	local relative_path = vim.fn.fnamemodify(full_path, ":~:." .. initial_cwd)
	vim.fn.setreg("+", relative_path)
	vim.notify("Copied to clipboard: " .. relative_path, vim.log.levels.INFO)
end, "Copy relative file path to clipboard")
