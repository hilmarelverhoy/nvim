-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd('packadd packer.nvim')
vim.cmd('packadd cfilter')

return require('packer').startup(function(use)
    use 'ThePrimeagen/vim-be-good'
    use 'mracos/mermaid.vim'
    use 'wbthomason/packer.nvim'
    use 'seblj/roslyn.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-project.nvim'}
    use({"isak102/telescope-git-file-history.nvim"})-- use("nathom/filetype.nvim")
    -- use "~\\telescope-git-file-history.nvim"
    use "sindrets/diffview.nvim"
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
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "Issafalcon/neotest-dotnet",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim"
        }
    }
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

    use{"iabdelkareem/csharp.nvim",
        requires = {
            "Tastyep/structlog.nvim"
        }}
    use({
        'EdenEast/nightfox.nvim',
        as = 'nightfox',
        config = function()
            vim.cmd('colorscheme nightfox')
        end
    })
    use {
        "rest-nvim/rest.nvim",
        tag="v1.2.1",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("rest-nvim").setup({
                -- Open request results in a horizontal split
                result_split_horizontal = false,
                -- Keep the http file buffer above|left when split horizontal|vertical
                result_split_in_place = false,
                -- stay in current windows (.http file) or change to results window (default)
                stay_in_current_window_after_split = false,
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
                    -- table of curl `--write-out` variables or false if disabled
                    -- for more granular control see Statistics Spec
                    show_statistics = false,
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
                -- for telescope select
                env_pattern = "\\.env$",
                env_edit_command = "tabedit",
                custom_dynamic_variables = {},
                yank_dry_run = true,
                search_back = true,
            })
        end
    }
    use({
        "GustavEikaas/easy-dotnet.nvim",
        requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
        config = function()
            local function get_secret_path(secret_guid)
      local path = ""
      local home_dir = vim.fn.expand('~')
      if require("easy-dotnet.extensions").isWindows() then
        local secret_path = home_dir ..
            '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. secret_guid .. "\\secrets.json"
        path = secret_path
      else
        local secret_path = home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
        path = secret_path
      end
      return path
    end

    local dotnet = require("easy-dotnet")
    -- Options are not required
    dotnet.setup({
      --Optional function to return the path for the dotnet sdk (e.g C:/ProgramFiles/dotnet/sdk/8.0.0)
      get_sdk_path = get_sdk_path,
      ---@type TestRunnerOptions
      test_runner = {
        ---@type "split" | "float" | "buf"
        viewmode = "float",
        enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
        noBuild = true,
        noRestore = true,
          icons = {
            passed = "",
            skipped = "",
            failed = "",
            success = "",
            reload = "",
            test = "",
            sln = "󰘐",
            project = "󰘐",
            dir = "",
            package = "",
          },
        mappings = {
          run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
          filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
          debug_test = { lhs = "<leader>d", desc = "debug test" },
          go_to_file = { lhs = "g", desc = "got to file" },
          run_all = { lhs = "<leader>R", desc = "run all tests" },
          run = { lhs = "<leader>r", desc = "run test" },
          peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
          expand = { lhs = "o", desc = "expand" },
          expand_node = { lhs = "E", desc = "expand node" },
          expand_all = { lhs = "-", desc = "expand all" },
          collapse_all = { lhs = "W", desc = "collapse all" },
          close = { lhs = "q", desc = "close testrunner" },
          refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" }
        },
        --- Optional table of extra args e.g "--blame crash"
        additional_args = {}
      },
      ---@param action "test" | "restore" | "build" | "run"
      terminal = function(path, action)
        local commands = {
          run = function()
            return "dotnet run --project " .. path
          end,
          test = function()
            return "dotnet test " .. path
          end,
          restore = function()
            return "dotnet restore " .. path
          end,
          build = function()
            return "dotnet build " .. path
          end
        }
        local command = commands[action]() .. "\r"
        vim.cmd("vsplit")
        vim.cmd("term " .. command)
      end,
      secrets = {
        path = get_secret_path
      },
      csproj_mappings = true,
      fsproj_mappings = true,
      auto_bootstrap_namespace = true
    })

    -- Example command
    vim.api.nvim_create_user_command('Secrets', function()
      dotnet.secrets()
    end, {})

    -- Example keybinding
    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_project()
    end)
        end
    })

end)
