return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	build = ":TSUpdate",
	config = function()
		-- Register custom parsers first
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		-- Add Zine-related parsers
		parser_config.ziggy = {
			install_info = {
				url = "https://github.com/kristoff-it/ziggy",
				files = { "tree-sitter-ziggy/src/parser.c" },
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "ziggy",
		}

		parser_config.ziggy_schema = {
			install_info = {
				url = "https://github.com/kristoff-it/ziggy",
				files = { "tree-sitter-ziggy-schema/src/parser.c" },
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "ziggy-schema",
		}

		parser_config.supermd = {
			install_info = {
				url = "https://github.com/kristoff-it/supermd",
				includes = { "tree-sitter/supermd/src" },
				files = {
					"tree-sitter/supermd/src/parser.c",
					"tree-sitter/supermd/src/scanner.c"
				},
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "supermd",
		}

		parser_config.supermd_inline = {
			install_info = {
				url = "https://github.com/kristoff-it/supermd",
				includes = { "tree-sitter/supermd-inline/src" },
				files = {
					"tree-sitter/supermd-inline/src/parser.c",
					"tree-sitter/supermd-inline/src/scanner.c"
				},
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "supermd_inline",
		}

		parser_config.superhtml = {
			install_info = {
				url = "https://github.com/kristoff-it/superhtml",
				includes = { "tree-sitter-superhtml/src" },
				files = {
					"tree-sitter-superhtml/src/parser.c",
					"tree-sitter-superhtml/src/scanner.c"
				},
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "superhtml",
		}

		-- Then setup treesitter
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua", "json", "yaml", "zig", "python", "go", "rust",
				"vimdoc", "markdown", "markdown_inline", "html", "bash", "mermaid",
				"ziggy", "ziggy_schema", "supermd", "supermd_inline", "superhtml"
			},
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
