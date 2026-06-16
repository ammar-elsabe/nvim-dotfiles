local options = {
  lsp_fallback = true,

  formatters = {
    dart_format = {
      prepend_args = { "--line-length", "100" },
    },
  },

  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    go = { "goimports", "golines" },
    terraform = { "terraform_fmt" },
    python = { "ruff_format" },
    dart = { "dart_format" },
    bzl = { "buildifier" },
    bazel = { "buildifier", lsp_format = "fallback" },
    solidity = { lsp_format = "always" },
  },

  -- format_on_save = {
  --   timeout_ms = 1000,
  --   lsp_fallback = true,
  -- },
}

return options
