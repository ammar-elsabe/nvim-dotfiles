require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>w", "<cmd> Neoformat| w <CR>", { desc = "Save file" })
map("n", "<leader>dl", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })
--
map("n", "<leader>dN", function()
  vim.diagnostic.goto_prev { float = { border = "rounded" } }
end, { desc = "Goto prev" })

map("n", "<leader>dn", function()
  vim.diagnostic.goto_next { float = { border = "rounded" } }
end, { desc = "Goto next" })
