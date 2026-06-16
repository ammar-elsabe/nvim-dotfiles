require("nvim-treesitter").install({
  "lua",
  "markdown",
  "markdown_inline",
  "rust",
  "sql",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- Let treesitter injections (SQL in sqlx macros) take priority
-- over rust-analyzer semantic tokens for string content
vim.api.nvim_set_hl(0, "@lsp.type.string.rust", {})
