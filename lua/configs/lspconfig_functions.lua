require("nvchad.configs.lspconfig").defaults()

local map = vim.keymap.set

local M = {}

-- `vim.ui.select` / `vim.ui.input` are global hooks owned by snacks.nvim
-- (see lua/plugins/init.lua), so nothing needs to be swapped in here.
function M.run_range_code_action(t)
	t = t or {}
	vim.lsp.buf.code_action({
		context = { diagnostics = vim.diagnostic.get() },
		range = t.range,
	})
end

function M.run_code_action()
	vim.lsp.buf.code_action()
end

local on_attach = function(client, bufnr)
	-- delete the existing ca mappings
	map("n", "<leader>ca", M.run_code_action, { desc = "LSP Code Action" })
	map("v", "<leader>ca", M.run_range_code_action, { desc = "LSP Range Code Action" })
	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end
end

return {
	on_attach = on_attach,
}
