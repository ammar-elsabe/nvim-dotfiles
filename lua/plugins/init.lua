return {
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "ray-x/navigator.lua",
    dependencies = {
      { "ray-x/guihua.lua" },
      { "neovim/nvim-lspconfig" },
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- optional
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    opts = function()
      return {
        ["dap_debug"] = false,
      }
    end,
    -- config = function(_, _) end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function(_, _)
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = nil
          end,
          -- on_init = nvlsp.on_init,
          -- capabilities = nvlsp.capabilities,
          default_settings = {
            ["rust-analyzer"] = {
              ["cargo"] = {
                ["features"] = "all",
              },
            },
          },
        },
      }
    end,
  },
  {
    "pappasam/nvim-repl",
    opts = function()
      return {
        filetype_commands = {
          bash = "bash",
          javascript = "node",
          haskell = "ghci",
          ocaml = { cmd = "utop", suffix = ";;" },
          python = "python",
          r = "R",
          sh = "sh",
          vim = "nvim --clean -ERM",
          zsh = "zsh",
        },
      }
    end,
    cmd = "ReplToggle",
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
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope-ui-select.nvim" },
    cmd = "Telescope",
    lazy = false,
    config = function(_, _)
      local actions = require "telescope.actions"
      local open_with_trouble = require("trouble.sources.telescope").open

      -- Use this to add more results without clearing the trouble list
      local add_to_trouble = require("trouble.sources.telescope").add

      local telescope = require "telescope"

      telescope.setup {
        defaults = {
          mappings = {
            i = { ["<c-t>"] = open_with_trouble },
            n = { ["<c-t>"] = open_with_trouble },
          },
        },

        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown {},
        },
      }
      telescope.load_extension "ui-select"
    end,
  },
  {
    "folke/trouble.nvim",
    opts = function()
      return {
        max_items = 200000,
      }
    end,
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
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
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
