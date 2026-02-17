local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local cmp = require('cmp')

local function setup_lsp_keymaps(event)
    local options = { buffer = event.buf }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, options)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, options)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, options)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, options)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, options)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, options)
    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, options)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_next, options)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, options)
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.incoming_calls, options)
    vim.keymap.set('n', '<leader>lo', vim.lsp.buf.outgoing_calls, options)
    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, options)
    vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, options)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, options)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, options)
end
-- vim.lsp.config('basedpyright', { root_markers = {'.git'} })
-- require("venv-lsp").setup()
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = setup_lsp_keymaps
})


local function setup_pyright_ls(server_name)
    vim.lsp.config(server_name, {
        cmd = { 'basedpyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { '.git', 'pyproject.toml', 'setup.py', 'requirements.txt' },
        capabilities = lsp_capabilities,
        on_attach = function(client, bufnr)
            client.server_capabilities.definitionProvider = true
        end,
        settings = {
            basedpyright = {
                analysis = {
                    typeCheckingMode = 'basic',
                    useLibraryCodeForTypes = true,
                    autoImportCompletionsd= true,
                    autoSearchPaths= false,
                    baselineFile                    = "",
                    diagnosticMode                  = "nFilesOnly",
                    diagnosticSeverityOverrides = {
                        reportAbstractUsage = "error",
                        reportAny                              = "none",
                        reportArgumentType                     = "error",
                        reportAssertAlwaysTrue                 = "warning",
                        reportAssertTypeFailure                = "error",
                        reportAssignmentType                   = "error",
                        reportAttributeAccessIssue             = "error",
                        reportCallInDefaultInitializer         = "none",
                        reportCallIssue                        = "error",
                        reportConstantRedefinition             = "none",
                        reportDeprecated                       = "none",
                        reportDuplicateImport                  = "none",
                        reportExplicitAny                      = "none",
                        reportFunctionMemberAccess             = "error",
                        reportGeneralTypeIssues                = "error",
                        reportIgnoreCommentWithoutRule         = "none",
                        reportImplicitAbstractClass            = "none",
                        reportImplicitOverride                 = "none",
                        reportImplicitRelativeImport           = "none",
                        reportImplicitStringConcatenation      = "none",
                        reportImportCycles                     = "none",
                        reportIncompatibleMethodOverride       = "error",
                        reportIncompatibleUnannotatedOverride  = "none",
                        reportIncompatibleVariableOverride     = "error",
                        reportIncompleteStub                   = "none",
                        reportInconsistentConstructor          = "none",
                        reportInconsistentOverload             = "error",
                        reportIndexIssue                       = "error",
                        reportInvalidAbstractMethod            = "none",
                        reportInvalidCast                      = "none",
                        reportInvalidStringEscapeSequence      = "warning",
                        reportInvalidStubStatement             = "none",
                        reportInvalidTypeArguments             = "error",
                        reportInvalidTypeForm                  = "error",
                        reportInvalidTypeVarUse                = "warning",
                        reportMatchNotExhaustive               = "none",
                        reportMissingImports                   = "error",
                        reportMissingModuleSource              = "warning",
                        reportMissingParameterType             = "none",
                        reportMissingSuperCall                 = "none",
                        reportMissingTypeArgument              = "none",
                        reportMissingTypeStubs                 = "none",
                        reportNoOverloadImplementation         = "error",
                        reportOperatorIssue                    = "error",
                        reportOptionalCall                     = "error",
                        reportOptionalContextManager           = "error",
                        reportOptionalIterable                 = "error",
                        reportOptionalMemberAccess             = "error",
                        reportOptionalOperand                  = "error",
                        reportOptionalSubscript                = "error",
                        reportOverlappingOverload              = "error",
                        reportPossiblyUnboundVariable          = "error",
                        reportPrivateImportUsage               = "error",
                        reportPrivateLocalImportUsage          = "none",
                        reportPrivateUsage                     = "none",
                        reportPropertyTypeMismatch             = "none",
                        reportRedeclaration                    = "error",
                        reportReturnType                       = "error",
                        reportSelfClsParameterName             = "warning",
                        reportShadowedImports                  = "none",
                        reportTypeCommentUsage                 = "none",
                        reportTypedDictNotRequiredAccess       = "error",
                        reportUnannotatedClassAttribute        = "none",
                        reportUnboundVariable                  = "error",
                        reportUndefinedVariable                = "error",
                        reportUnhashable                       = "error",
                        reportUninitializedInstanceVariable    = "none",
                        reportUnknownArgumentType              = "none",
                        reportUnknownLambdaType                = "none",
                        reportUnknownMemberType                = "none",
                        reportUnknownParameterType             = "none",
                        reportUnknownVariableType              = "none",
                        reportUnnecessaryCast                  = "none",
                        reportUnnecessaryComparison            = "none",
                        reportUnnecessaryContains              = "none",
                        reportUnnecessaryIsInstance            = "none",
                        reportUnnecessaryTypeIgnoreComment     = "none",
                        reportUnreachable                      = "none",
                        reportUnsafeMultipleInheritance        = "none",
                        reportUnsupportedDunderAll             = "warning",
                        reportUntypedBaseClass                 = "none",
                        reportUntypedClassDecorator            = "none",
                        reportUntypedFunctionDecorator         = "none",
                        reportUntypedNamedTuple                = "none",
                        reportUnusedCallResult                 = "none",
                        reportUnusedClass                      = "none",
                        reportUnusedCoroutine                  = "error",
                        reportUnusedExcept                     = "error",
                        reportUnusedExpression                 = "warning",
                        reportUnusedFunction                   = "none",
                        reportUnusedImport                     = "none",
                        reportUnusedParameter                  = "hint",
                        reportUnusedVariable                   = "none",
                        reportWildcardImportFromLibrary        = "warning",
                    },
                    exclude = {
                        "**/node_modules",
                        "**/__pycache__",
                        "**/.venv",
                        "**/.git",
                        "**/.hg",
                        "**/.svn",
                        "**/.tox",
                        "**/.mypy_cache",
                        "**/.pytest_cache",
                    },
                    extraPaths                      = {},
                    fileEnumerationTimeout          = 10,
                    ignore                          ={},
                    include                         = {},
                    inlayHints = {
                        callArgumentNames    = true,
                        functionReturnTypes  = true,
                        genericTypes         = false,
                        variableTypes        = true,
                    },
                },
                logLevel              = "Information",
                stubPath              = "typings",
                typeCheckingMode      = "recommended",
                typeshedPaths         ={},
                useTypingExtensions   = false
            },
        },
    })
    vim.lsp.enable(server_name)
end
local function setup_lua_ls(server_name)
    vim.lsp.config(server_name, {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.git', '.luarc.json' },
        capabilities = lsp_capabilities,
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = {
                    globals = { 'vim', 'require' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
            },
        },
    })
    vim.lsp.enable(server_name)
end
local function get_commit_messave()
   
end
local function setup_csharp_ls(server_name)
    vim.lsp.config(server_name, {
        cmd = { 'csharp-ls' },
        filetypes = { 'csharp' },
        root_markers = { '.git', 'sln', 'csproj' },
        capabilities = vim.tbl_deep_extend("force", lsp_capabilities, {
            semanticTokensProvider = { full = true }
        }),
    })
    vim.lsp.enable(server_name)
end
local default_setup = function(server)
    vim.lsp.config(server, {
        capabilities = lsp_capabilities,
        on_attach = function(client, bufnr)
        end
    })
    vim.lsp.enable(server)
end

local function setup_ty_ls(server_name)
    -- Detect virtual environment
    local function get_python_path(workspace)
        -- Check for venv in workspace
        local venv_path = workspace .. '/venv/bin/python'
        if vim.fn.executable(venv_path) == 1 then
            return venv_path
        end
        -- Fallback to system python
        return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
    end

    -- Configure the server
    vim.lsp.config(server_name, {
        capabilities = lsp_capabilities,
        cmd = { 'ty' }, -- Ensure the 'ty' command is in your PATH
        filetypes = { 'python' },
        root_markers = { '.git', 'pyproject.toml', 'setup.py', '.ty-root', 'pyrightconfig.json' },
        single_file_support = true,
        before_init = function(params)
            local workspace = params.workspaceFolders and params.workspaceFolders[1] and params.workspaceFolders[1].name or vim.fn.getcwd()
            params.initializationOptions = params.initializationOptions or {}
            params.initializationOptions.settings = params.initializationOptions.settings or {}
            -- params.initializationOptions.settings.python = {
            --     pythonPath = get_python_path(workspace),
            --     venvPath = workspace,
            --     venv = '.venv'
            -- }
        end,
        settings = {
            python = {
                pythonPath = get_python_path(vim.fn.getcwd()),
                venvPath = vim.fn.getcwd(),
                venv = 'venv'
            }
        }
    })
    
    -- Enable the server after configuration
    vim.lsp.enable(server_name)
end

require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})
require('mason-lspconfig').setup({
    automatic_enable = true,
    ensure_installed = {},
    handlers = {
        default_setup,
        lua_ls = setup_lua_ls,
        csharp_ls = setup_csharp_ls,
        basedpyright = setup_pyright_ls,
    }
})

-- Setup ty server (not managed by Mason)
-- Configure first
local function get_python_path(workspace)
    local venv_path = workspace .. '/venv/bin/python'
    if vim.fn.executable(venv_path) == 1 then
        return venv_path
    end
    return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

vim.lsp.config('ty', {
    capabilities = lsp_capabilities,
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = { '.git', 'pyproject.toml', 'setup.py', '.ty-root', 'pyrightconfig.json' },
    single_file_support = true,
    before_init = function(params)
        
        local workspace = params.workspaceFolders and params.workspaceFolders[1] and params.workspaceFolders[1].name or vim.fn.getcwd()
        
        params.initializationOptions = params.initializationOptions or {}
        params.initializationOptions.settings = params.initializationOptions.settings or {}
        params.initializationOptions.settings.python = {
            pythonPath = get_python_path(workspace),
            venvPath = workspace,
            venv = 'venv'
        }
        
    end,
    on_init = function(client, result)
    end,
    settings = {
        python = {
            pythonPath = get_python_path(vim.fn.getcwd()),
            venvPath = vim.fn.getcwd(),
            venv = 'venv'
        }
    }
})

-- Enable it
vim.lsp.enable('ty')

require("mason-nvim-dap").setup()
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'copilot', group_index = 2 },
        { name = 'luasnip' },
        { name = 'buffer', option = { keyword_pattern = [[\k\+]] } },
        { name = 'path' },
    })
})
local config = {
    csharp_cmd_path = vim.fn.has('win32') == 1 and 
        [[C:\Users\ELVHIL\AppData\Local\nvim-data\mason\bin\csharp-ls.CMD]] or 
        'csharp-ls',
    hilmar_ls_path = vim.fn.has('win32') == 1 and
        [[C:\Users\ELVHIL\hilmar_ls\bin\Release\net8.0\publish\hilmar_ls.exe]] or
        'hilmar_ls',
}

require('csharp').setup({
    lsp = {
        roslyn = {
            enable = false,
            cmd_path = config.csharp_cmd_path
        }
    },
    capabilities = lsp_capabilities,
})


vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
    pattern = {'*.dart'},
    callback = function()
        vim.lsp.start({
            name = 'dart-ls',
            cmd = {
                'dart',
                'language-server',
                '--client-id',
                '--nvim.hilmare',
                '--client-version',
                '1.2'
            },
            root_dir = vim.fs.root(0, {'pubspec.yaml'}),
            filetypes = { 'dart' },
        })
    end
})

vim.diagnostic.config({
    virtual_text = false,
})
