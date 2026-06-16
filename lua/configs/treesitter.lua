require("nvim-treesitter").install({
  "bash",
  "c",
  "css",
  "dockerfile",
  "go",
  "hcl",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "solidity",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- Let treesitter injections (SQL in sqlx macros) take priority
-- over rust-analyzer semantic tokens for string content
vim.api.nvim_set_hl(0, "@lsp.type.string.rust", {})
