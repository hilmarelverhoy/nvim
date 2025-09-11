local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local util = require('lspconfig.util')
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

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = setup_lsp_keymaps
})

local default_setup = function(server)
    require('lspconfig')[server].setup({
        capabilities = lsp_capabilities,
        on_attach = function(client, bufnr)
        end
    })
end

local function setup_pyright_ls()
    require('lspconfig').basedpyright.setup({
        capabilities = lsp_capabilities,
        on_attach = function(client, bufnr)
            client.server_capabilities.definitionProvider = false
        end,
        settings = {
            basedpyright = {
                analysis = {
                    typeCheckingMode = 'basic',
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    autoImportCompletionsd= true,
                    autoSearchPaths= true,
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
                useLibraryCodeForTypes= true,
                useTypingExtensions   = false
            },
        },
    })
end
local function setup_lua_ls()
    require('lspconfig').lua_ls.setup({
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
end

local function setup_csharp_ls()
    require('lspconfig').csharp_ls.setup({
        capabilities = vim.tbl_deep_extend("force", lsp_capabilities, {
            semanticTokensProvider = { full = true }
        }),
    })
end

require('mason').setup({})
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
