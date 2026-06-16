require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both"
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
