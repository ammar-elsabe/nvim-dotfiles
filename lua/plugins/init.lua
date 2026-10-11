return {
  -- Keep NvChad ui + base46 on the same branch so the base46 cache
  -- (e.g. the "blink" highlights file) matches what ui expects. Without
  -- this, ui follows its v3.0 default while base46 stays on v2.5 (cmp-only),
  -- which breaks blink.cmp's config step.
  { "nvchad/ui", branch = "v3.0" },
  {
    "nvchad/base46",
    branch = "v3.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "rauls-kjarners/omp.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ao",
        function()
          Snacks.terminal.toggle("omp", {
            win = {
              position = "right",
              width = 0.4,
            },
          })
        end,
      },
    },
  },
  {
    "nwiizo/codex.nvim",

    cmd = {
      "Codex",
      "CodexFocus",
      "CodexSendVisual",
      "CodexAddVisual",
    },

    opts = {
      backend = "terminal",

      -- Don't jump into Codex every time you send something
      focus_after_send = false,

      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
      },
    },

    keys = {
      {
        "<leader>cx",
        "<cmd>Codex<cr>",
        desc = "Codex: Toggle",
      },
      {
        "<leader>cs",
        ":<C-U>CodexAddVisual<CR>",
        mode = "v",
        desc = "Codex: Send selection",
      },
    },
  },
  {
    "nickjvandyke/opencode.nvim",
    version = "*", -- Latest stable release
    ---@type opencode.Opts
    opts = {},
    config = function(_, opts)
      vim.g.opencode_opts = opts
    end,
    -- Recommended/example keymaps
    keys = {
      {
        "<leader>oa",
        function()
          require("opencode").ask "@this: "
        end,
        mode = { "n", "x" },
        desc = "Ask OpenCode…",
      },

      {
        "<leader>os",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Select OpenCode…",
      },

      {
        "go",
        function()
          return require("opencode").operator "@this "
        end,
        mode = { "n", "x" },
        desc = "Append range to OpenCode",
        expr = true,
      },

      {
        "goo",
        function()
          return require("opencode").operator "@this " .. "_"
        end,
        mode = "n",
        desc = "Append line to OpenCode",
        expr = true,
      },

      {
        "<S-C-u>",
        function()
          require("opencode").command "session.half.page.up"
        end,
        mode = "n",
        desc = "Scroll OpenCode up",
      },

      {
        "<S-C-d>",
        function()
          require("opencode").command "session.half.page.down"
        end,
        mode = "n",
        desc = "Scroll OpenCode down",
      },
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    opts = {
      terminal_cmd = vim.fn.exepath "claude",
      focus_after_send = true,
      diff_opts = {
        layout = "unified",
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
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
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      return {
        dap_debug = false,
      }
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  { "wsdjeg/toml.nvim" },
  {
    "mrcjkb/rustaceanvim",
    lazy = false, -- This plugin is already lazy
    config = function(_, _)
      local cargoConfigPath = vim.fn.getcwd() .. "/.cargo/config.toml"

      local cargoConfigExists = vim.uv.fs_stat(cargoConfigPath) ~= nil

      local extraEnv = nil

      if cargoConfigExists then
        local toml = require "toml"
        local cargoConfig = toml.parse_file(cargoConfigPath)
        extraEnv = cargoConfig.env
      end

      vim.g.rustaceanvim = {
        server = {
          -- on_init = nvlsp.on_init,
          -- capabilities = nvlsp.capabilities,
          default_settings = {
            ["rust-analyzer"] = {
              ["cargo"] = {
                extraEnv = extraEnv,
                buildScripts = {
                  enable = true,
                },
              },
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
  -- NvChad still specs telescope. enabled=false is what keeps it from loading.
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
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
      {
        "<leader>fm",
        function()
          require("conform").format { async = true }
        end,
        mode = "",
        desc = "File Format with conform",
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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
  { import = "nvchad.blink.lazyspec" },
  {
    "simrat39/inlay-hints.nvim",
  },
  -- Owns `vim.ui.select` (Snacks.picker.select) and `vim.ui.input` (Snacks.input).
  -- Picker replaces the telescope finders. `<c-t>` / `<c-a>` inside a picker open/add in Trouble.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true, -- sets vim.ui.select
        actions = {
          trouble_open = {
            action = function(picker)
              require("trouble.sources.snacks").open(picker)
            end,
            desc = "Open in Trouble",
          },
          trouble_add = {
            action = function(picker)
              require("trouble.sources.snacks").open(picker, { add = true })
            end,
            desc = "Add to Trouble",
          },
        },
        win = {
          input = {
            keys = {
              ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
              ["<c-a>"] = { "trouble_add", mode = { "n", "i" } },
            },
          },
          list = {
            keys = {
              ["<c-t>"] = { "trouble_open", mode = { "n", "x" } },
              ["<c-a>"] = { "trouble_add", mode = { "n", "x" } },
            },
          },
        },
      },
    },
  },
  -- {
  -- 	"leoluz/nvim-dap-go",
  -- },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require "configs.dapui_config"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require "configs.dap"
    end,
  },
  {
    "nanotee/sqls.nvim",
  },
}
