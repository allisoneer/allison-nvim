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

			-- Global capabilities: CMP + UFO folding
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- Apply global defaults for all servers
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Invoke our existing keymap logic on attach via autocmd
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end
					on_attach(client, ev.buf)
				end,
			})

			-- Per-server configuration (must execute BEFORE mason-lspconfig.setup)
			local servers = require("plugins/lsp/servers")
			for name, cfg in pairs(servers) do
				vim.lsp.config(name, cfg or {})
			end

			-- Mason setup
			require("mason").setup()

			-- Install and automatically enable all configured servers
			local ensure_installed = {}
			for name, _ in pairs(servers) do
				table.insert(ensure_installed, name)
			end

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_enable = true, -- Neovim 0.11 native API pattern
			})
		end,
	},
	formatter,  -- This is the only conform spec now (from format.lua)
}
