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
    "ray-x/navigator.lua",
    dependencies = {
      { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
      { "neovim/nvim-lspconfig" },
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
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

      local extraEnv = {}

      if cargoConfigExists then
        local toml = require "toml"
        local cargoConfig = toml.parse_file(cargoConfigPath)
        if cargoConfig.env ~= nil then
          extraEnv = cargoConfig.env
        end
      end

      vim.g.rustaceanvim = {
        server = {
          -- on_init = nvlsp.on_init,
          -- capabilities = nvlsp.capabilities,
          default_settings = {
            ["rust-analyzer"] = {
              ["cargo"] = {
                --   -- ["features"] = "all",
                extraEnv = extraEnv,
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
            i = { ["<c-t>"] = open_with_trouble, ["<c-a>"] = add_to_trouble },
            n = { ["<c-t>"] = open_with_trouble, ["<c-a>"] = add_to_trouble },
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
  {
    "stevearc/dressing.nvim",
    lazy = false,
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
