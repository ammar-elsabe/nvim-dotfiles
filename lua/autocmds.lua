-- Auto-cd to the project root on buffer enter (replaces the unmaintained
-- ahmedkhalf/project.nvim, which crashed on the removed vim.lsp.buf_get_clients).
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("auto_root", { clear = true }),
  callback = function(args)
    -- only act on normal file buffers
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local root = vim.fs.root(args.buf, {
      ".git",
      "Makefile",
      "Cargo.toml",
      "go.mod",
      "package.json",
      ".project-root",
    })

    if root and root ~= vim.uv.cwd() then
      vim.uv.chdir(root)
    end
  end,
})
