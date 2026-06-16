require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

map("i", "<C-e>", [[copilot#Accept("<Right>")]], {
	silent = true,
	expr = true,
	script = true,
	replace_keycodes = false,
})

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>dN", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostic set loclist" })

-- Lua
map("n", "<leader>tx", function()
	require("trouble").toggle()
end, { desc = "Trouble" })
map("n", "<leader>tw", function()
	require("trouble").toggle("workspace_diagnostics")
end, { desc = "Trouble Workspace Diagnostics" })
map("n", "<leader>td", function()
	require("trouble").toggle("document_diagnostics")
end, { desc = "Trouble Document Diagnostics" })
map("n", "<leader>tq", function()
	require("trouble").toggle("quickfix")
end, { desc = "Trouble Quickfix" })
map("n", "<leader>tl", function()
	require("trouble").toggle("loclist")
end, { desc = "Trouble Loclist" })
map("n", "gR", function()
	require("trouble").toggle("lsp_references")
end, { desc = "LSP References" })

local function switch_case()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local word = vim.fn.expand("<cword>")
	local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

	-- Detect camelCase
	if word:find("[a-z][A-Z]") then
		-- Convert camelCase to snake_case
		local snake_case_word = word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
	-- Detect snake_case
	elseif word:find("_[a-z]") then
		-- Convert snake_case to camelCase
		local camel_case_word = word:gsub("(_)([a-z])", function(_, l)
			return l:upper()
		end)
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
	else
		print("Not a snake_case or camelCase word")
	end
end

map("n", "<leader>sc", switch_case, { desc = "Switch Case" })
