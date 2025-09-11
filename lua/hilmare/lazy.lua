-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- AI/Copilot plugins
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  },
  
  -- Utilities
  "ThePrimeagen/vim-be-good",
  "mracos/mermaid.vim",
  {
    "ckolkey/ts-node-action",
    config = function()
      require("ts-node-action").setup({})
    end
  },
  
  -- Language support
  "HallerPatrick/py_lsp.nvim",
  
  -- Git/GitHub
  {
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" }
  },

  -- Telescope and extensions
  {
    "nvim-telescope/telescope.nvim", 
    tag = "0.1.4",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  "nvim-telescope/telescope-project.nvim",
  "isak102/telescope-git-file-history.nvim",
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  "sindrets/diffview.nvim",
  {
    "Equilibris/nx.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("nx").setup {}
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",

  },
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-refactor",
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  "RRethy/nvim-treesitter-textsubjects",
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup {
        snippet_engine = "luasnip"
      }
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = "*"
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "Issafalcon/neotest-dotnet",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  },

  -- Vim plugins
  "tpope/vim-dispatch",
  "tpope/vim-fugitive",
  "tpope/vim-commentary",
  "tpope/vim-abolish",
  "tpope/vim-repeat",
  "tpope/vim-surround",

  -- Utilities
  "farmergreg/vim-lastplace",
  "tmadsen/vim-compiler-plugin-for-dotnet",
  "nvim-tree/nvim-web-devicons",

  -- DAP (Debug Adapter Protocol)
  {
    "rcarriga/nvim-dap-ui", 
    dependencies = { "mfussenegger/nvim-dap" }
  },
  "jay-babu/mason-nvim-dap.nvim",
  "mfussenegger/nvim-dap-python",

  -- LSP and completion
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path", 
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "onsails/lspkind.nvim",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    }
  },

  "seblj/nvim-lsp-extras",
  "seblj/roslyn.nvim",
  "andymass/vim-matchup",
  "folke/snacks.nvim",
  "coder/claudecode.nvim",

  {
    "iabdelkareem/csharp.nvim",
    dependencies = { "Tastyep/structlog.nvim" }
  },
  -- Colorscheme
  -- {
  --   "EdenEast/nightfox.nvim",
  --   name = "nightfox",
  --   config = function()
  --     vim.cmd("colorscheme nightfox")
  --   end
  -- },

  -- REST client
  {
    "rest-nvim/rest.nvim",
    version = "v1.2.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        stay_in_current_window_after_split = false,
        skip_ssl_verification = false,
        encode_url = true,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          show_url = true,
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          show_statistics = false,
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
            end
          },
        },
        jump_to_request = false,
        env_file = ".env",
        env_pattern = "\\.env$",
        env_edit_command = "tabedit",
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      })
    end
  },
})