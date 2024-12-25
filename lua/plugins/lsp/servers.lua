local cwd = vim.fn.getcwd()

local function is_zml_project()
	return vim.endswith(cwd, "zml") or
			vim.endswith(cwd, "zml/examples")
end

local zls_config = {}
if is_zml_project() then
	-- In ZML project, use the project's custom ZLS and Zig
	zls_config = {
		cmd = { cwd .. "/tools/zls.sh" },
		settings = {
			zls = {
				enable_autofix = true,
				zig_exe_path = cwd .. "/tools/zig.sh",
			},
		},
	}
else
	-- Default configuration for other projects
	zls_config = {
		cmd = { vim.fs.normalize("~/.local/bin/zls") },
		settings = {
			zls = {
				enable_autofix = true,
			},
		},
	}
end

return {
	gopls = {},
	rust_analyzer = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
	zls = zls_config,
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
