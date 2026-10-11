require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

local function pick_term()
  local found = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      found = true
      break
    end
  end
  if not found then
    vim.notify("no terminal buffers are opened/hidden!", vim.log.levels.WARN)
    return
  end
  Snacks.picker.buffers {
    hidden = true,
    current = true,
    title = "Pick Term",
    filter = {
      filter = function(item)
        return item.buftype == "terminal"
      end,
    },
    confirm = function(picker, item)
      picker:close()
      if not item or not item.buf or vim.fn.bufwinid(item.buf) ~= -1 then
        return
      end
      local termopts = vim.g.nvchad_terms and vim.g.nvchad_terms[tostring(item.buf)]
      if termopts then
        require("nvchad.term").display(termopts)
      else
        vim.api.nvim_set_current_buf(item.buf)
      end
    end,
  }
end

-- :lua local t = Snacks.terminal.get("bash", { create = false }); if t then t:close() end
map("n", "<leader>st", function()
  local t = Snacks.terminal.get(nil, {
    create = false
  });
  if t then t:close() end
end, { desc = "stop terminal" })
map("n", "<leader>h", function()
  Snacks.terminal.toggle(nil, {
    win = {
      position = "right",
      height = 0.35,
    },
  })
end, { desc = "horizontal split terminal" })
map("n", "<leader>v", function()
  Snacks.terminal.toggle(nil, {
    win = {
      position = "bottom",
      height = 0.35,
    },
  })
end, { desc = "vertical split terminal" })
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fa", function()
  Snacks.picker.files { hidden = true, ignored = true, follow = true }
end, { desc = "Find all files" })
map("n", "<leader>fw", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Find buffers" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help pages" })
map("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "Find oldfiles" })
map("n", "<leader>fz", function()
  Snacks.picker.lines()
end, { desc = "Find in current buffer" })
map("n", "<leader>ma", function()
  Snacks.picker.marks()
end, { desc = "Find marks" })
map("n", "<leader>cm", function()
  Snacks.picker.git_log()
end, { desc = "Git commits" })
map("n", "<leader>gt", function()
  Snacks.picker.git_status()
end, { desc = "Git status" })
map("n", "<leader>pt", pick_term, { desc = "Pick hidden term" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

map("i", "<C-e>", [[copilot#Accept("<Right>")]], {
  silent = true,
  expr = true,
  script = true,
  replace_keycodes = false,
})

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

map("n", "<leader>dl", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>dN", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostic set loclist" })

-- Lua
map("n", "<leader>tx", function()
  require("trouble").toggle()
end, { desc = "Trouble" })
map("n", "<leader>tw", function()
  require("trouble").toggle "workspace_diagnostics"
end, { desc = "Trouble Workspace Diagnostics" })
map("n", "<leader>td", function()
  require("trouble").toggle "document_diagnostics"
end, { desc = "Trouble Document Diagnostics" })
map("n", "<leader>tq", function()
  require("trouble").toggle "quickfix"
end, { desc = "Trouble Quickfix" })
map("n", "<leader>tl", function()
  require("trouble").toggle "loclist"
end, { desc = "Trouble Loclist" })
map("n", "gR", function()
  require("trouble").toggle "lsp_references"
end, { desc = "LSP References" })

local function switch_case()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local word = vim.fn.expand "<cword>"
  local word_start = vim.fn.matchstrpos(vim.fn.getline ".", "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

  -- Detect camelCase
  if word:find "[a-z][A-Z]" then
    -- Convert camelCase to snake_case
    local snake_case_word = word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
  -- Detect snake_case
  elseif word:find "_[a-z]" then
    -- Convert snake_case to camelCase
    local camel_case_word = word:gsub("(_)([a-z])", function(_, l)
      return l:upper()
    end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
  else
    print "Not a snake_case or camelCase word"
  end
end

map("n", "<leader>sc", switch_case, { desc = "Switch Case" })

map("n", "<leader>ip", function()
  local venv = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX"
  if venv ~= nil then
    venv = string.match(venv, "/.+/(.+)")
    vim.cmd(("MoltenInit %s"):format(venv))
  else
    vim.cmd "MoltenInit python3"
  end
end, { desc = "Initialize Molten for python3", silent = true })
