-- Load dependencies at module level with error handling
local ok_trouble, trouble = pcall(require, "trouble")
local ok_telescope, builtin = pcall(require, "telescope.builtin")

local function on_attach(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	-- Check server capabilities before binding keys
	if client.server_capabilities.renameProvider then
		nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	end

	if client.server_capabilities.codeActionProvider then
		nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	end

	-- Use telescope if available, fallback to vim.lsp.buf
	if ok_telescope then
		nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
		nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
		nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
		nmap("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
		nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
		nmap("<leader>ws", builtin.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
	else
		nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
		nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	end

	if ok_trouble then
		nmap("<leader>dd", trouble.toggle, "[D]iagnostic [D]etails")
	else
		nmap("<leader>dd", vim.diagnostic.setloclist, "[D]iagnostic [D]etails")
	end

	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")
end

return on_attach
