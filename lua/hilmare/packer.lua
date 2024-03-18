-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd('packadd packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'jmederosalvarado/roslyn.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-project.nvim'}
    use{"keyvchan/telescope-running-commands.nvim"}
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
    use {
    'Equilibris/nx.nvim',
    requires = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        require("nx").setup {}
    end
}

  use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
  use('nvim-treesitter/playground')
  use('nvim-treesitter/nvim-treesitter-refactor')
  use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
  })
  use('RRethy/nvim-treesitter-textsubjects')
  use {
      "danymat/neogen",
      config = function()
          require('neogen').setup {
              snippet_engine = "luasnip"
          }

      end,
      requires = "nvim-treesitter/nvim-treesitter",
      -- Uncomment next line if you want to follow only stable versions
      tag = "*"
  }
use {"folke/neodev.nvim"}
use {
  "nvim-neotest/neotest",
  requires = {
    "nvim-lua/plenary.nvim",
    "Issafalcon/neotest-dotnet",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim"
  }
}

  use('mbbill/undotree')
  use('tpope/vim-dispatch')
  use('tpope/vim-fugitive')
  use('tpope/vim-commentary')
  use('tpope/vim-abolish')
  use('tpope/vim-repeat')
  use('tpope/vim-surround')

  -- Opends files at last edit position
  use('farmergreg/vim-lastplace')
  use('tmadsen/vim-compiler-plugin-for-dotnet')
  use('nvim-tree/nvim-web-devicons')

  use({ "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} })
  use("jay-babu/mason-nvim-dap.nvim")

  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use {"neovim/nvim-lspconfig"}
  use {
      'hrsh7th/nvim-cmp',
      requires = {
          -- Autocompletion
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'saadparwaiz1/cmp_luasnip'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
      }
  }

  use('andymass/vim-matchup')

  -- use('junegunn/vim-easy-align')
  use({
      'EdenEast/nightfox.nvim',
      as = 'nightfox',
      config = function()
          vim.cmd('colorscheme nightfox')
      end
  })
  use({"isak102/telescope-git-file-history.nvim"})-- use("nathom/filetype.nvim")

  use {
      "rest-nvim/rest.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
          require("rest-nvim").setup({
              -- Open request results in a horizontal split
              result_split_horizontal = false,
              -- Keep the http file buffer above|left when split horizontal|vertical
              result_split_in_place = false,
              -- Skip SSL verification, useful for unknown certificates
              skip_ssl_verification = false,
              -- Encode URL before making request
              encode_url = true,
              -- Highlight request on run
              highlight = {
                  enabled = true,
                  timeout = 150,
              },
              result = {
                  -- toggle showing URL, HTTP info, headers at top the of result window
                  show_url = true,
                  -- show the generated curl command in case you want to launch
                  -- the same request via the terminal (can be verbose)
                  show_curl_command = false,
                  show_http_info = true,
                  show_headers = true,
                  -- executables or functions for formatting response body [optional]
                  -- set them to false if you want to disable them
                  formatters = {
                      json = "jq",
                      html = function(body)
                          return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
                      end
                  },
              },
              -- Jump to request line on run
              jump_to_request = false,
              env_file = '.env',
              custom_dynamic_variables = {},
              yank_dry_run = true,
          })
      end
  }
end)
