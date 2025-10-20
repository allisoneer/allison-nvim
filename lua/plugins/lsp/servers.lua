-- Detect a ZML project root for the given buffer.
-- Returns the absolute path to the 'zml' root (if found), otherwise nil.
local function detect_zml_root_for_buf(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if not bufname or bufname == "" then
		return nil
	end
	local dir = vim.fs.dirname(bufname)
	if not dir or dir == "" then
		return nil
	end

	local function basename(p)
		if not p or p == "" then
			return nil
		end
		local trimmed = p:gsub("[/\\]+$", "")
		return trimmed:match("([^/\\]+)$")
	end

	-- Direct checks for current dir
	if basename(dir) == "zml" then
		return dir
	end
	if basename(dir) == "examples" then
		local parent = vim.fs.dirname(dir)
		if parent and basename(parent) == "zml" then
			return parent
		end
	end

	-- Ascend parents
	for parent in vim.fs.parents(dir) do
		local b = basename(parent)
		if b == "zml" then
			return parent
		end
		if b == "examples" then
			local gp = vim.fs.dirname(parent)
			if gp and basename(gp) == "zml" then
				return gp
			end
		end
	end
	return nil
end

return {
	gopls = {},
	rust_analyzer = {},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
	zls = {
		-- Select binary dynamically per buffer
		cmd = function()
			local bufnr = vim.api.nvim_get_current_buf()
			local root = detect_zml_root_for_buf(bufnr)
			if root then
				return { root .. "/tools/zls.sh" }
			end
			return { "zls" } -- Mason/system PATH
		end,
		settings = {
			zls = {
				enable_autofix = true,
				-- Note: zls.sh is expected to handle zig executable configuration for ZML projects
			},
		},
	},
	biome = {},
	clangd = {},
	pyright = {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
				venvPath = ".",
				pythonPath = ".venv/bin/python",
			},
		},
	},
	ts_ls = {},
}
