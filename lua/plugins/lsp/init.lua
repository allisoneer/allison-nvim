local formatter = require("plugins/lsp/format")
local on_attach = require("plugins/lsp/lsp_attach")

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			{ "j-hui/fidget.nvim",       opts = {} },

			"folke/neodev.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("neodev").setup()

			-- Get default capabilities with CMP enhancements
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Add folding range support for UFO
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local servers = require("plugins/lsp/servers")

			-- Setup Mason first
			require("mason").setup()

			-- Build ensure_installed list (exclude servers with custom cmd)
			local ensure_installed = {}
			for server_name, server in pairs(servers) do
				if server.cmd == nil then
					table.insert(ensure_installed, server_name)
				end
			end

			-- Setup mason-lspconfig with handlers
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
			})

			-- Use handlers to setup each server with correct order
			require("mason-lspconfig").setup_handlers({
				-- Default handler for all servers
				function(server_name)
					local server_config = servers[server_name] or {}
					local config = vim.tbl_deep_extend("force", {
						capabilities = capabilities,
						on_attach = on_attach,
					}, server_config)

					require("lspconfig")[server_name].setup(config)
				end,
			})
		end,
	},
	formatter,  -- This is the only conform spec now (from format.lua)
}