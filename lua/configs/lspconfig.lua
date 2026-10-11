local funcs = require "configs.lspconfig_functions"
local on_attach = funcs.on_attach

require("nvchad.configs.lspconfig").defaults()
require "lspconfig"

vim.filetype.add {
  pattern = {
    [".*.bazelrc"] = "bazelrc",
  },
}

vim.lsp.inlay_hint.enable()

local map = vim.keymap.set
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("v", "<leader>ca", function(t)
  t = t or {}
  vim.lsp.buf.code_action {
    context = { diagnostics = vim.diagnostic.get() },
    range = t.range,
  }
end, { desc = "LSP Range Code Action" })

local servers = {
  "jsonnet_ls",
  "starpls",
  "lua_ls",
  "pyright",
  "terraformls",
  "tflint",
  "docker_compose_language_service",
  "dockerls",
  "sqlls",
  "clangd",
  "ts_ls",
  "svelte",
  "buf_ls",
  "circom-lsp",
  "cairo_ls",
  "gopls",
  "dartls",
  "texlab",
  "eslint",
  "ruby_lsp",
  "sqls",
  "julials",
  "bazelrc_lsp",
  "solidity_ls_nomicfoundation",
  "html",
  "cssls",
  "ruff",
  "jsonls",
}
vim.lsp.enable(servers, true)

-- for _, lsp in ipairs(servers) do
--   vim.lsp.config(lsp, {
--     on_attach = on_attach,
--   })
-- end

vim.lsp.config("cairo_ls", {
  on_attach = on_attach,
  cmd = { "scarb", "cairo-language-server", "/c", "--node-ipc" },
  filetypes = { "cairo" },
})

require("go").setup {}

local cfg = require("go.lsp").config()

cfg["on_attach"] = on_attach
cfg["settings"]["gopls"]["analyses"]["shadow"] = false

vim.lsp.config("gopls", cfg)

-- dartls
vim.lsp.config("dartls", {
  on_attach = on_attach,
  settings = {
    dart = {
      lineLength = 100,
    },
  },
})

vim.lsp.config("texlab", {
  on_attach = on_attach,
  settings = {
    texlab = {
      build = {
        executable = "pdflatex",
        args = { "--shell-escape", "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = true,
      },
    },
  },
})

-- ruby
vim.lsp.config("ruby_lsp", {
  on_attach = on_attach,
})

-- sqls
vim.lsp.config("sqls", {
  on_attach = function(client, buffer)
    require("sqls").on_attach(client, buffer)
    on_attach(client, buffer)
  end,
  settings = {
    sqls = {
      connections = {
        {
          driver = "postgresql",
          dataSourceName = "host=127.0.0.1 port=5432 user=postgres password=postgres dbname=postgres sslmode=disable",
        },
      },
    },
  },
})

-- clangd
vim.lsp.config("clangd", {
  on_attach = on_attach,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})

return {
  on_attach = on_attach,
}
