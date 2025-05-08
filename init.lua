-- Store initial working directory for relative path calculations
vim.g.initial_working_directory = vim.fn.getcwd()

require("allison.settings")
require("allison.keymap")
require("allison.lazy")
