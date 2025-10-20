return {
	"stevearc/conform.nvim",

	-- Load for real files early enough that format_after_save is registered
	event = { "BufReadPre", "BufNewFile" },

	-- Manual formatting remains available and can also trigger loading
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 3000 })
			end,
			desc = "Format buffer",
		},
	},

	-- Backstop for: nvim → type in [No Name] → :w file.ext
	-- Ensures conform is loaded before the ensuing BufWritePost
	init = function()
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("LazyConformBackstop", { clear = true }),
			once = true,
			callback = function(args)
				local buf = args.buf
				-- Only consider normal, modifiable file-like buffers
				if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
					return
				end
				-- If not loaded yet, load synchronously so BufWritePost hooks are registered
				local ok = pcall(require, "conform")
				if not ok then
					require("lazy").load({ plugins = { "conform.nvim" } })
				end
			end,
		})
	end,

	opts = {
		-- Convert to function to filter non-file buffers; return nil to skip
		format_after_save = function(bufnr)
			if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
				return nil
			end
			return {
				async = true,
				lsp_fallback = true,
				timeout_ms = 3000, -- 3 second timeout
			}
		end,

		formatters_by_ft = {
			-- Fallback chains
			json = { "biome", "prettierd", "jq" },
			lua = { "stylua" },
			python = { "black" },
			["c++"] = { "clang-format" },
			javascript = { "prettierd", "biome" },
			typescript = { "prettierd", "biome" },
			javascriptreact = { "prettierd", "biome" },
			typescriptreact = { "prettierd", "biome" },
			-- Zine formats
			superhtml = { "superhtml" },
			ziggy = { "ziggy" },
			ziggy_schema = { "ziggy_schema" },
		},

		formatters = {
			-- Zine formatters
			superhtml = {
				inherit = false,
				command = "superhtml",
				stdin = true,
				args = { "fmt", "--stdin-super" },
			},
			ziggy = {
				inherit = false,
				command = "ziggy",
				stdin = true,
				args = { "fmt", "--stdin" },
			},
			ziggy_schema = {
				inherit = false,
				command = "ziggy",
				stdin = true,
				args = { "fmt", "--stdin-schema" },
			},
		},
	},
}
