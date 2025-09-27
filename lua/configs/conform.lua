local options = {
  formatters = {
    dart_format = {
      append_args = { "--line-length", "100" },
    },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    dart = { "dart_format" },
    css = { "prettier" },
    html = { "prettier" },
    go = { "golines" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
