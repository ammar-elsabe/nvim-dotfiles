local options = {
	lsp_fallback = true,
	-- formatters = {
	-- 	dart_format = {
	-- 		prepend_args = { "--line-length", "100" },
	-- 		command = { "dart format" },
	-- 	},
	-- },

	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
		go = { "golines" },
		terraform = { "terraform_fmt" },
		python = { "ruff_format" },
    dart = { "dart_format" },
    bzl = { "buildifier" },
    solidity = { lsp_format = "always" }
	},
	format_on_save = nil,
}

return options
