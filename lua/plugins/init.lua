return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function(_, _)
      local nvlsp = require "nvchad.configs.lspconfig"
      vim.g.rustaceanvim = {
        server = {
          on_attach = nvlsp.on_attach,
          on_init = nvlsp.on_init,
          capabilities = nvlsp.capabilities,
        },
      }
    end,
  },
  {
    "pappasam/nvim-repl",
    init = function()
      vim.g["repl_filetype_commands"] = {
        bash = "bash",
        javascript = "node",
        haskell = "ghci",
        ocaml = { cmd = "utop", suffix = ";;" },
        python = "ipython --no-autoindent",
        r = "R",
        sh = "sh",
        vim = "nvim --clean -ERM",
        zsh = "zsh",
      }
    end,
    cmd = "ReplOpen",
    keys = {
      { "<Leader>cc", "<Cmd>ReplNewCell<CR>", mode = "n", desc = "Create New Cell" },
      { "<Leader>cr", "<Plug>(ReplSendCell)", mode = "n", desc = "Send Repl Cell" },
      { "<Leader>r", "<Plug>(ReplSendLine)", mode = "n", desc = "Send Repl Line" },
      { "<Leader>r", "<Plug>(ReplSendVisual)", mode = "x", desc = "Send Repl Visual Selection" },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    lazy = false,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    cmd = "Oil",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      local actions = require "telescope.actions"
      local open_with_trouble = require("trouble.sources.telescope").open

      -- Use this to add more results without clearing the trouble list
      local add_to_trouble = require("trouble.sources.telescope").add

      opts["defaults"]["mappings"]["i"] = { ["<c-t>"] = open_with_trouble }
      opts["defaults"]["mappings"]["n"] = { ["<c-t>"] = open_with_trouble }

      require("telescope").setup(opts)
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>tx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>tb",
        "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
        desc = "ERROR Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format { async = true }
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    opts = function()
      return {
        manual_mode = false,
      }
    end,
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      local myConfigs = require "configs.nvimtree"
      local nvchadConfigs = require "nvchad.configs.nvimtree"
      local ret = {}
      for k, v in pairs(nvchadConfigs) do
        ret[k] = v
      end
      for k, v in pairs(myConfigs) do
        ret[k] = v
      end
      return ret
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
    end,
  },
}
