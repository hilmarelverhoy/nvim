vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local options = { buffer = event.buf }

        -- these will be buffer-local keybindings
        -- because they only work if you have an active language server
        
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, options)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, options)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, options)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, options)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, options)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, options)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, options)
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.incoming_calls, options)
        vim.keymap.set("n", "<leader>lo", vim.lsp.buf.outgoing_calls, options)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, options)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, options)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, options)
        -- vim.keymap.set("n", "go", vim.lsp., options)
    end
})
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local default_setup = function(server)
    require('lspconfig')[server].setup({
        capabilities = lsp_capabilities,
        on_attach = function (client, bufnr)
            -- print(vim.inspect(client.server_capabilities))
        end
    })
end
require('mason').setup({})
require('mason-lspconfig').setup({
    automatic_enable = true,
    ensure_installed = {},
    handlers = {
        default_setup,
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                capabilities = lsp_capabilities,
                on_attach = function (client, bufnr)
                    -- print(vim.inspect(client.server_capabilities))
                end,
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = {
                            globals = {
                                'vim',
                                'require'
                            },
                        },
                        signature_help = true,
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,
        csharp_ls = function ()
            require'lspconfig'.csharp_ls.setup({
                capabilities = vim.tbl_deep_extend("force", lsp_capabilities, {semanticTokensProvider = {full=true}}),
                on_attach = function (client, bufnr)
                    -- print(vim.inspect(client.server_capabilities))
                end,
                settings = {

                }

            })
        end,
        -- basedpyright = function()
        --     -- Diagnostic settings
        --     vim.diagnostic.config {
        --         virtual_text = false,
        --         signs = false,
        --         underline = true,
        --     }
        -- end
    }

})
local util = require 'lspconfig.util'

-- vim.lsp.start({
--     name = 'dart-ls',
--     cmd = { 'dart',
--         'language-server',
--         '--client-id',
--         '--nvim.hilmare',
--         '--client-version',
--             '1.2' },
--     root_dir = vim.fs.root(0, {'pubspec.yaml'}),
--   filetypes = { 'dart' },
--  })
require("mason-nvim-dap").setup()

-- require("roslyn").setup({
--     dotnet_cmd = "dotnet", -- this is the default
--     -- roslyn_version = "4.8.0-3.23475.7", -- this is the default
--     roslyn_version = "4.9.0-3.23604.10",
--     capabilities = lsp_capabilities, -- required
--     on_attach = function(client)
--         -- make sure this happens once per client, not per buffer
--         if not client.is_hacked then
--             client.is_hacked = true

--             -- let the runtime know the server can do semanticTokens/full now
-- client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
--                 semanticTokensProvider = {
--                     full = true,
--                 },
--             })

--             -- monkey patch the request proxy
--             local request_inner = client.request
--             client.request = function(method, params, handler)
--                 if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
--                     return request_inner(method, params, handler)
--                 end

--                 local function find_buf_by_uri(search_uri)
--                     local bufs = vim.api.nvim_list_bufs()
--                     for _, buf in ipairs(bufs) do
--                         local name = vim.api.nvim_buf_get_name(buf)
--                         local uri = "file://" .. name
--                         if uri == search_uri then
--                             return buf
--                         end
--                     end
--                 end

--                 local doc_uri = params.textDocument.uri

--                 local target_bufnr = find_buf_by_uri(doc_uri)
--                 local line_count = vim.api.nvim_buf_line_count(target_bufnr)
--                 local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

--                 return request_inner("textDocument/semanticTokens/range", {
--                     textDocument = params.textDocument,
--                     range = {
--                         ["start"] = {
--                             line = 0,
--                             character = 0,
--                         },
--                         ["end"] = {
--                             line = line_count - 1,
--                             character = string.len(last_line) - 1,
--                         },
--                     },
--                 }, handler)
--             end
--         end 
--     end,
--     settings = {

--     }
-- })
local cmp = require('cmp')

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- Enter key confirms completion item
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Ctrl + space triggers completion menu
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})

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
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = "copilot", group_index = 2 },
        { name = 'luasnip' },
        { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
        { name = "path" },
    })
})
require"csharp".setup({
    lsp = {
        roslyn = {
            enable = false,
            cmd_path = [[C:\Users\ELVHIL\AppData\Local\nvim-data\mason\bin\csharp-ls.CMD]]
        }

    },
    capabilities = lsp_capabilities,
})
-- vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
--     pattern = {"*.cs"},
--     callback = function ()
--         vim.lsp.start({
--             name = 'c_sharp_ls',
--             cmd = {'csharp-ls.exe'},
--             filetypes = { 'cs' },
--             root_dir = vim.fs.dirname(vim.fs.find({"*.sln"}, {upward = true})[1]),
--         })
--     end
-- })

-- vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
--     pattern = {"*.lua"},
--     callback = function ()
--         vim.lsp.start({
--             name = 'lua_lsp',
--             cmd = {'lua-language-server.exe'},
--             filetypes = { 'lua' },
--             single_file_support = true,
-- })


vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
    pattern = {"*.dart"},
    callback = function ()
        vim.lsp.start({
            name = 'dart-ls',
            cmd = { 'dart',
                'language-server',
                '--client-id',
                '--nvim.hilmare',
                '--client-version',
                '1.2' },
            root_dir = vim.fs.root(0, {'pubspec.yaml'}),
            filetypes = { 'dart' },
        })
    end
})

vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
    pattern = {"*.test"},
    callback = function ()
        vim.lsp.start({
            name = 'hilmar_ls',
            cmd = {[[C:\Users\ELVHIL\hilmar_ls\bin\Release\net8.0\publish\hilmar_ls.exe]]},
            filetypes = { 'cs' },
            root_dir = vim.fs.dirname(vim.fs.find({"*.sln"}, {upward = true})[1]),
        })
    end
})



-- lsp.set_preferences({
--     suggest_lsp_servers = false,
--     sign_icons = {
--         error = 'E',
--         warn = 'W',
--         hint = 'H',
--         info = 'I'
--     }
-- })

-- lsp.on_attach(function(client, bufnr)
--   local options = {buffer = bufnr, remap = false}

--   if client.name == "eslint" then
--       vim.cmd.LspStop('eslint')
--       return
--   end

--   vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
--   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, options)
--   vim.keymap.set("n", "gi", vim.lsp.buf.implementation, options)
--   vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
--   vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
--   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, options)
--   vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, options)
--   vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, options)
--   vim.keymap.set("n", "[d", vim.diagnostic.goto_next, options)
--   vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, options)
--   vim.keymap.set("n", "<leader>li", vim.lsp.buf.incoming_calls, options)
--   vim.keymap.set("n", "<leader>lo", vim.lsp.buf.outgoing_calls, options)
--   vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, options)
--   vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, options)
--   vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, options)
-- end)

-- lsp.setup()
vim.diagnostic.config({
    virtual_text = true,
})
