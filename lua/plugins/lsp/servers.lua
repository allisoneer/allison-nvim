-- Function to get ZLS config based on current directory
local function get_zls_config()
	local cwd = vim.fn.getcwd()
	local is_zml = vim.endswith(cwd, "zml") or vim.endswith(cwd, "zml/examples")

	if is_zml then
		return {
			cmd = { cwd .. "/tools/zls.sh" },
			settings = {
				zls = {
					enable_autofix = true,
					zig_exe_path = cwd .. "/tools/zig.sh",
				},
			},
		}
	else
		return {
			cmd = { vim.fs.normalize("~/.local/bin/zls") },
			settings = {
				zls = {
					enable_autofix = true,
				},
			},
		}
	end
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
	zls = get_zls_config(),  -- Call function to get config
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
