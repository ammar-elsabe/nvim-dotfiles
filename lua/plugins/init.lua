return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      instructions_file = "CLAUDE.md",
      provider = "claude-code",
      acp_providers = {
        ["claude-code"] = {
          command = "bunx",
          args = { "-y", "@zed-industries/claude-code-acp" },
          env = {
            HOME = os.getenv("HOME"),
            NODE_NO_WARNINGS = "1",
            ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
            ACP_PERMISSION_MODE = "bypassPermissions",
          },
        },
        ["opencode"] = {
          command = "opencode",
          args = { "acp" },
        },
        ["codex"] = {
          command = "bunx",
          args = { "-y", "@zed-industries/codex-acp" },
          env = {
            HOME = os.getenv("HOME"),
            NODE_NO_WARNINGS = "1",
            ACP_PATH_TO_CODEX_EXECUTABLE = vim.fn.exepath("codex"),
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
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
	{ import = "nvchad.blink.lazyspec" },
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	{
		"akinsho/git-conflict.nvim",
		lazy = false,
		config = true,
	},
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
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("configs.dapui_config")
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("configs.dap")
		end,
	},
	{
		"nanotee/sqls.nvim",
	},
	{
		"ahmedkhalf/project.nvim",
		lazy = false,
		config = function()
			require("configs.project")
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		init = function()
			local lspconfigs = require("configs.lspconfig_functions")
			-- rust
			vim.g.rustaceanvim = {
				server = {
					on_attach = lspconfigs.on_attach,
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								features = "all",
								extraEnv = {
									ENTRYPOINT_JSON_PATH = "contracts/out/EntryPoint.sol/EntryPoint.json",
									MANDATE_REGISTRY_JSON_PATH = "contracts/out/MandateRegistry.sol/MandateRegistry.json",
									SETTLEMENT_ROUTER_JSON_PATH = "contracts/out/SettlementRouter.sol/SettlementRouter.json",
									INVOICE_ACCOUNT_JSON_PATH = "contracts/out/InvoiceAccount.sol/InvoiceAccount.json",
									INVOICE_FACTORY_JSON_PATH = "contracts/out/InvoiceFactory.sol/InvoiceFactory.json",
									MOCK_ERC20_JSON_PATH = "contracts/out/MockERC20.sol/MockERC20.json",
									PUBLIC_ERC6492_VALIDATOR_JSON_PATH = "contracts/out/PublicERC6492Validator.sol/PublicERC6492Validator.json",
								},
							},
						},
					},
				},
			}
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope-ui-select.nvim" },
		cmd = "Telescope",
		lazy = false,
		config = function(_, _)
			local actions = require("telescope.actions")
			local open_with_trouble = require("trouble.sources.telescope").open

			-- Use this to add more results without clearing the trouble list
			local add_to_trouble = require("trouble.sources.telescope").add

			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					mappings = {
						i = { ["<c-t>"] = open_with_trouble, ["<c-a>"] = add_to_trouble },
						n = { ["<c-t>"] = open_with_trouble, ["<c-a>"] = add_to_trouble },
					},
				},

				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			telescope.load_extension("ui-select")
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
	-- In order to modify the `lspconfig` configuration:
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
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
	{
		"stevearc/conform.nvim",
		opts = require("configs.conform"),
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>fm",
				function()
					require("conform").format({ async = true })
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
		opts = function()
			return require("configs.nvim-tree")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		lazy = false,
		opts = function()
			return require("configs.treesitter")
		end,
	},
}
