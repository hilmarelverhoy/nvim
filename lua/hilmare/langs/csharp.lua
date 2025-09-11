local M = {}

local function get_filename()
    return vim.fn.expand("%:t:r")
end

local function makename(args)
    local a = args[1][1]:sub(1, 2)
    local b = args[1][1]:sub(3)
    if a:sub(1, 1) == "I" then
        a = a:sub(2, 2)
    else
        b = args[1][1]:sub(3)
    end
    a = a:lower()
    return a .. b
end

function get_class_name()
    local opts = {}
    opts["bufnr"] = 0
    opts["pos"] = nil
    local node = vim.treesitter.get_node(opts)
    if not node then
        return nil
    end
    local next = node:parent()
    while next do
        if next:type() == "class_declaration" then
            local t = next:iter_children()
            for index, _ in t do
                if index:type() == "identifier" then
                    local start_col, start_row, end_col, end_row = index:range()
                    local text = vim.api.nvim_buf_get_text(0, start_col, start_row, end_col, end_row, {});
                    return text[1]
                end
            end
        end
        next = next:parent()
    end
    return vim.fn.expand("%:t:r")
end

function M.setup_snippets()
    local ls = require("luasnip")
    local text = ls.text_node
    local insert = ls.insert_node
    local f = ls.function_node

    ls.add_snippets("cs", {
        ls.snippet("fn", {
            ls.choice_node(4, {text("public"), text("private")}),
            text(" "),
            insert(3, "Type"),
            text(" "),
            insert(1),
            text("("),
            insert(2, "int foo"),
            text({ ")", "" }),
            text({ "{", "\t" }),
            insert(0),
            text({ "", "}" }),
        }),
        ls.snippet("afn", {
            ls.choice_node(4, {text("public"), text("private")}),
            text(" async "),
            ls.choice_node(3, {
                ls.snippet_node(nil, {
                    text("Task<"),
                    insert(1, "Type"),
                    text(">")
                }),
                text("Task"),
                text("void")
            }),
            text(" "),
            insert(1),
            text("("),
            insert(2, "int foo"),
            text({ ")", "" }),
            text({ "{", "\t" }),
            insert(0),
            text({ "", "}" }),
        }),
        ls.snippet("cls", {
            ls.choice_node(2, {text("public"), text("protected"), text("private"), text("internal")}),
            text(" class "),
            f(get_filename),
            text({ "", "" }),
            text({ "{", "\t" }),
            insert(3, {"Type variable", ""}),
            text({ "", "\t" }),
            ls.choice_node(1, {text("public"), text("protected"), text("private"), text("internal")}),
            text({" "}),
            f(get_filename),
            text({ "()", "\t" }),
            text({ "{", "\t\t" }),
            insert(0),
            text({ "", "\t}" }),
            text({ "", "}" }),
        }),
        ls.snippet("ctor", {
            text("public "),
            f(get_class_name),
            text("()", ""),
            text({ "{", "\t" }),
            insert(0),
            text({ "", "}" }),
        }),
        ls.snippet("inst", {
            text("private readonly "),
            insert(1, "Type"),
            text(" _"),
            f(makename, 1),
            insert(2),
            text({";", ""}),
        })
    }, {key = "csharp"})
end

function M.setup_keymaps()
    -- C# specific buffer keymaps
    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        pattern = {"*.cs", "*.csproj", "*.cshtml", "*.targets"},
        callback = function()
            local opts = { buffer = true }
            vim.keymap.set("n", "<localleader>r", function()
                require("neotest").run.run()
            end, opts)
            vim.keymap.set("n", "<localleader>R", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, opts)
            vim.keymap.set("n", "<localleader>m", ":wa<Enter>:Make<Enter>", opts)
        end
    })

    -- HTTP file keymaps
    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        pattern = {"*.http"},
        callback = function()
            local opts = { buffer = true }
            vim.keymap.set("n", "<localleader>r", "<Plug>RestNvim", opts)
            vim.keymap.set("n", "<localleader>p", "<Plug>RestNvimPreview", opts)
        end
    })
end

function M.setup_compiler()
    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        pattern = {"*.cs", "*.csproj", "*.targets"},
        command = "compiler dotnet",
    })
end

function M.setup()
    M.setup_snippets()
    M.setup_keymaps()
    M.setup_compiler()
    
    -- Setup neogen for C#
    require('neogen').setup {
        enabled = true,
        languages = {
            cs = {
                template = {
                    annotation_convention = "xmldoc"
                }
            },
        }
    }
end

return M