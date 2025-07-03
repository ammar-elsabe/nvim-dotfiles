require("nvchad.configs.lspconfig").defaults()
require "lspconfig"

vim.lsp.inlay_hint.enable()

local servers =
  { "html", "cssls", "pyright", "dartls", "ts_ls", "ruff", "gopls", "clangd", "buf_ls", "cairo_ls", "texlab" }

-- lsps with default config
-- for _, lsp in ipairs(servers) do
--   vim.lsp.config(lsp, {
--     on_attach = nvlsp.on_attach,
--     on_init = nvlsp.on_init,
--     capabilities = nvlsp.capabilities,
--   })
-- end
vim.lsp.enable(servers, true)

-- vim.lsp.config("buf_ls", {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   filetypes = { "proto" },
-- })
-- vim.lsp.enable("buf_ls", true)

vim.lsp.config("cairo_ls", {
  -- on_attach = nvlsp.on_attach,
  -- on_init = nvlsp.on_init,
  -- capabilities = nvlsp.capabilities,
  cmd = { "scarb", "cairo-language-server", "/C", "--node-ipc" },
  filetypes = { "cairo" },
})
-- vim.lsp.enable("cairo_ls", true)

vim.lsp.config("clangd", {
  -- on_attach = nvlsp.on_attach,
  -- on_init = nvlsp.on_init,
  -- capabilities = nvlsp.capabilities,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})
-- vim.lsp.enable("clangd", true)

vim.lsp.config("texlab", {
  -- on_attach = nvlsp.on_attach,
  -- on_init = nvlsp.on_init,
  -- capabilities = nvlsp.capabilities,
  settings = {
    texlab = {
      build = {
        executable = "pdflatex",
        args = { "--shell-escape", "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
      },
    },
  },
})
-- vim.lsp.enable("texlab", true)

-- configuring single server, example: typescript
-- vim.lsp.config("ts_ls", {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
