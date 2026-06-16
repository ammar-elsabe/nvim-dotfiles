require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both"
o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk, buffer reloaded!", vim.log.levels.INFO)
	end,
})
