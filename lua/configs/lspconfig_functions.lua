require("nvchad.configs.lspconfig").defaults()

local map = vim.keymap.set

local M = {}
M.input = require("guihua.input").input
M.select = require("guihua.gui").select

function M.run_range_code_action(t)
	local context = {}
	t = t or {}
	context.diagnostics = vim.diagnostic.get()

	local original_select = vim.ui.select
	local original_input = vim.ui.input

	vim.ui.select = M.select
	vim.ui.input = M.input
	vim.lsp.buf.code_action({
		context = context,
		range = t.range,
	})
	vim.defer_fn(function()
		vim.ui.select = original_select
		vim.ui.input = original_input
	end, 1000)
end

function M.run_code_action()
	local original_select = vim.ui.select
	local original_input = vim.ui.input
	vim.ui.select = M.select
	vim.ui.input = M.input

	if vim.api.nvim_get_mode().mode ~= "v" then
		vim.lsp.buf.code_action()
	else
		vim.lsp.buf.range_code_action()
	end

	vim.defer_fn(function()
		vim.ui.select = original_select
		vim.ui.input = original_input
	end, 1000)
end

local on_attach = function(client, bufnr)
	-- delete the existing ca mappings
	map("n", "<leader>ca", M.run_code_action, { desc = "LSP Code Action" })
	map("v", "<leader>ca", M.run_range_code_action, { desc = "LSP Range Code Action" })
	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.refresh()
	end
end

return {
	on_attach = on_attach,
}
