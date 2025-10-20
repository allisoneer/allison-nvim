return {
	"stevearc/conform.nvim",
	opts = {
		format_after_save = {
			async = true,
			lsp_fallback = true,
			timeout_ms = 3000,  -- 3 second timeout
		},
		formatters_by_ft = {
			-- Add fallback chains
			json = { "biome", "prettierd", "jq" },
			lua = { "stylua" },
			python = { "black" },
			["c++"] = { "clang-format" },
			javascript = { "prettierd", "biome" },
			typescript = { "prettierd", "biome" },
			javascriptreact = { "prettierd", "biome" },
			typescriptreact = { "prettierd", "biome" },
			-- Add Zine formats
			superhtml = { "superhtml" },
			ziggy = { "ziggy" },
			ziggy_schema = { "ziggy_schema" },
		},
		formatters = {
			-- Add Zine formatters
			superhtml = {
				inherit = false,
				command = 'superhtml',
				stdin = true,
				args = { 'fmt', '--stdin-super' },
			},
			ziggy = {
				inherit = false,
				command = 'ziggy',
				stdin = true,
				args = { 'fmt', '--stdin' },
			},
			ziggy_schema = {
				inherit = false,
				command = 'ziggy',
				stdin = true,
				args = { 'fmt', '--stdin-schema' },
			},
		}
	},
	config = function(conf)
		require("conform").setup(conf.opts)

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, { desc = "Format buffer" })
	end,
}
