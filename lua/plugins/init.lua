local function acp_env(extra)
  local env = vim.fn.environ()
  env.NODE_NO_WARNINGS = "1"
  for k, v in pairs(extra or {}) do
    env[k] = v
  end
  return env
end

return {
  {
    "ammar-elsabe/avante.nvim",
    branch = "fix/acp-follow-agent-locations",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    build = "make BUILD_FROM_SOURCE=true",
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      instructions_file = "CLAUDE.md",
      provider = "claude-code",
      mode = "agentic",
      behaviour = {
        auto_set_keymaps = true,
        minimize_diff = true,
        enable_token_counting = true,
        auto_approve_tool_permissions = true,
        acp_follow_agent_locations = true,
      },
      selector = {
        provider = "telescope",
      },
      windows = {
        width = 40,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
          include_model = true,
        },
      },
      acp_providers = {
        ["claude-code"] = {
          command = "bunx",
          args = { "-y", "@agentclientprotocol/claude-agent-acp@0.44" },
          env = acp_env(),
        },
        ["opencode"] = {
          command = "opencode",
          args = { "acp" },
          env = acp_env(),
        },
        ["codex"] = {
          command = "bunx",
          args = { "-y", "@zed-industries/codex-acp@0.16" },
          env = acp_env(),
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
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
    -- config = function(_, _) end,
  },
  {
    "mrcjkb/rustaceanvim",
    lazy = false, -- This plugin is already lazy
    config = function(_, _)
      vim.g.rustaceanvim = {
        server = {
          -- on_init = nvlsp.on_init,
          -- capabilities = nvlsp.capabilities,
          default_settings = {
            ["rust-analyzer"] = {
              ["cargo"] = {
                --   -- ["features"] = "all",
                extraEnv = {
                  ENTRYPOINT_JSON_PATH = "contracts/out/EntryPoint.sol/EntryPoint.json",
                  SELL_ORDER_REGISTRY_JSON_PATH = "contracts/out/SellOrderRegistry.sol/SellOrderRegistry.json",
                  SETTLEMENT_ROUTER_JSON_PATH = "contracts/out/SettlementRouter.sol/SettlementRouter.json",
                  INVOICE_ACCOUNT_JSON_PATH = "contracts/out/InvoiceAccount.sol/InvoiceAccount.json",
                  INVOICE_FACTORY_JSON_PATH = "contracts/out/InvoiceFactory.sol/InvoiceFactory.json",
                  MOCK_ERC20_JSON_PATH = "contracts/out/MockERC20.sol/MockERC20.json",
                  PUBLIC_ERC6492_VALIDATOR_JSON_PATH = "contracts/out/PublicERC6492Validator.sol/PublicERC6492Validator.json",
                },
              },
              -- linkedProjects = { "rust-project.json" },
            },
          },
        },
        dap = {
          autoload_configurations = false,
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
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require "configs.treesitter"
    end,
  },
}
