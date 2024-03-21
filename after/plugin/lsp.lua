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
        vim.keymap.set("n", "<d", vim.diagnostic.goto_next, options)
        vim.keymap.set("n", ">d", vim.diagnostic.goto_prev, options)
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.incoming_calls, options)
        vim.keymap.set("n", "<leader>lo", vim.lsp.buf.outgoing_calls, options)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, options)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, options)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, options)
    end
})
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- print(vim.inspect(lsp_capabilities))
-- print(vim.inspect(capabilities))
local default_setup = function(server)
    require('lspconfig')[server].setup({
        capabilities = lsp_capabilities,
        on_attach = function (client, bufnr)
            print(vim.inspect(client.server_capabilities))
        end
    })
end
require('mason').setup({})
require('mason-lspconfig').setup({
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
        end
    }

})
require("mason-nvim-dap").setup()
require("roslyn").setup({
    dotnet_cmd = "dotnet", -- this is the default
    -- roslyn_version = "4.8.0-3.23475.7", -- this is the default
    roslyn_version = "4.9.0-3.23604.10",
    capabilities = lsp_capabilities, -- required
    on_attach = function()
        print("hei")
    end,
})
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
        { name = 'luasnip' },
        { name = 'buffer' },
    })
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
