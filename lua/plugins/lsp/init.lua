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
			local lspconfig = require("lspconfig")

			-- Shared helper to setup any server consistently
			local function setup_server(server_name, servers, capabilities, on_attach)
				local server_config = servers[server_name] or {}
				local config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, server_config)
				lspconfig[server_name].setup(config)
			end

			-- Setup Mason first
			require("mason").setup()

			-- Build ensure_installed list (exclude servers with custom cmd)
			local ensure_installed = {}
			for server_name, server in pairs(servers) do
				if server.cmd == nil then
					table.insert(ensure_installed, server_name)
				end
			end

			-- Setup mason-lspconfig with handlers inline (correct API)
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				handlers = {
					-- Default handler for all mason-managed servers
					function(server_name)
						setup_server(server_name, servers, capabilities, on_attach)
					end,
				},
			})

			-- Manually setup servers that are not mason-managed:
			-- - Those with a custom cmd
			-- - Or explicitly marked mason=false (future flexibility)
			for server_name, server in pairs(servers) do
				if server.cmd ~= nil or server.mason == false then
					setup_server(server_name, servers, capabilities, on_attach)
				end
			end
		end,
	},
	formatter,  -- This is the only conform spec now (from format.lua)
}