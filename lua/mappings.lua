require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>W", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>dl", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })
--
map("n", "<leader>ip", function()
  local venv = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX"
  if venv ~= nil then
    -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    venv = string.match(venv, "/.+/(.+)")
    vim.cmd(("MoltenInit %s"):format(venv))
  else
    vim.cmd "MoltenInit python3"
  end
end, { desc = "Initialize Molten for python3", silent = true })
