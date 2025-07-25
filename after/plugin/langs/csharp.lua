-- local lspconfig = require'lspconfig'
-- lspconfig.csharp_ls.setup( {
--     root_dir = function(startpath)
--         return lspconfig.util.root_pattern("*.sln")(startpath)
--             or lspconfig.util.root_pattern("*.csproj")(startpath)
--             or lspconfig.util.root_pattern("*.fsproj")(startpath)
--             or lspconfig.util.root_pattern(".git")(startpath)
--     end
-- })
-- placeholder 2,...
local function copy(args)
	return args[1]
end
local ts_utils = require("nvim-treesitter.ts_utils")

local function makename(args)
     local a = args[1][1]:sub(1,2)
     local b = args[1][1]:sub(3)
     if a:sub(1,1) == "I" then
         a = a:sub(2,2)
     else
         b = args[1][1]:sub(3)

     end
     a = a:lower()
     return a..b
 end
 local function get_filename()
     return vim.fn.expand("%:t:r")
 end
function goto_name_identifier2()
    local ts_opts = {}
    ts_opts["bufnr"] = 0
    ts_opts["pos"] = nil
    local node = vim.treesitter.get_node(ts_opts)
    if not node then
        return nil
    end
    local next = node:prev_sibling()
    if next == nil then
        next = node:parent()
    end
    while next do
        if next:type() == "identifier" then
            local x,y,_,_ = next:range()

            vim.api.nvim_feedkeys("m'","n",false)
            vim.api.nvim_win_set_cursor(0, {x+1,y});
            return
        end
        local t = next:prev_sibling()
        if t == nil then
            t = next:parent()
            if t:type() == "compilation_unit" then
                return
            end
        end

        next = t
    end
    return nil
end

local function goto_name_identifier()
    local ts_opts = {}
    ts_opts["bufnr"] = 0
    ts_opts["pos"] = nil
    local node = vim.treesitter.get_node(ts_opts)
    if not node then
        return nil
    end
    local next = node:parent()
    while next do
        if next:type() == "assignment_expression" then
            local t = next:child(1):iter_children()
            for index, string in t do
                if string ~= nil then
                    print ("test" .. string)
                end
                if index ~= node and index:type() == "identifier" and string == "name" then
                    local x,y,z,w = index:range()

                    vim.api.nvim_feedkeys("m'","n",false)
                    vim.api.nvim_win_set_cursor(0, {x+1,y});
                    return
                end
            end

        end
        if next:type() == "variable_declaration" then
            local t = next:child(1):iter_children()
            for index, string in t do
                if index ~= node and index:type() == "identifier" and string == "name" then
                    local x,y,z,w = index:range()

                    vim.api.nvim_feedkeys("m'","n",false)
                    vim.api.nvim_win_set_cursor(0, {x+1,y});
                    return
                end
            end

        end
        if next:type() == "class_declaration" or next:type() == "variable_declarator" or next:type() == "method_declaration" then
            local t = next:iter_children()
            for index, string in t do
                if index ~= node and index:type() == "identifier" and string == "name" then
                    local x,y,z,w = index:range()
                    vim.api.nvim_feedkeys("m'","n",false)
                    vim.api.nvim_win_set_cursor(0, {x+1,y});
                    return
                end
            end
        end
        next = next:parent()
    end
end
local function goto_parent_node()
    local ts_opts = {}
    ts_opts["bufnr"] = 0
    ts_opts["pos"] = nil
    local node = vim.treesitter.get_node(ts_opts)
    if not node then
        return nil
    end
    local next = node
    while next do
        if next:type() == "class_declaration" or  next:type() == "method_declaration" then
            local t = next:iter_children()
            for index, string in t do
                if index ~= node and index:type() == "identifier" and string == "type" then
                    local x,y,_,_ = index:range()
                    vim.api.nvim_feedkeys("m'","n",false)

                    vim.api.nvim_win_set_cursor(0, {x+1,y});
                    return
                end
            end
        end
        if next:type() == "variable_declarator" then
            local t = next:parent():iter_children()
            for index, string in t do
                if index ~= node and string == "type"  then
                    local x,y,_,_ = index:range()
                    vim.api.nvim_feedkeys("m'","n",false)
                    vim.api.nvim_win_set_cursor(0, {x+1,y});
                    return
                end
            end
        end
        next = next:parent()
    end
end
vim.keymap.set("n","øgn",function ()
    goto_name_identifier2()
end,{})
vim.keymap.set("n","øgt",function ()
    goto_parent_node()
end,{})
local function get_class_name()
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
                    local text = vim.api.nvim_buf_get_text(0, start_col,start_row,end_col, end_row, {});
                    return text[1]
                end
            end
        end
        next = next:parent()
    end

    return vim.fn.expand("%:t:r")
end

local ls = require("luasnip")
local text = ls.text_node
local insert = ls.insert_node
local f = ls.function_node
ls.add_snippets("cs",{
    ls.snippet("fn", {
        -- Simple static text.
        -- function, first parameter is the function, second the Placeholders
        -- whose text it gets as input.
        ls.choice_node(4,{text("public"), text("private")}),
        text(" "),
        -- Placeholder/Insert.
        insert(3, "Type"),
        text(" "),
        insert(1),
        text("("),
        -- Placeholder with initial text.
        insert(2, "int foo"),
        text({ ")",""}),
        text({ "{"  ,"\t"}),
        -- Last Placeholder, exit Point of the snippet.
        insert(0),
        text({ "", "}" }),
    }),
    ls.snippet("afn", {
        -- Simple static text.
        -- function, first parameter is the function, second the Placeholders
        -- whose text it gets as input.
        ls.choice_node(4,{text("public"), text("private")}),
        text(" async "),
        -- Placeholder/Insert.
        ls.choice_node(3, {
            ls.snippet_node(nil,{
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
        -- Placeholder with initial text.
        insert(2, "int foo"),
        text({ ")",""}),
        text({ "{"  ,"\t"}),
        -- Last Placeholder, exit Point of the snippet.
        insert(0),
        text({ "", "}" }),
    }),
    ls.snippet("cls", {
        ls.choice_node(2,{text("public"),text("protected"), text("private"), text("internal")}), text(" class "), f(get_filename),
        text({ "" ,""}),
        -- todo: inheritance
        text({ "{" ,"\t" }),
        insert(3, {"Type variable", ""}),
        text({ ""  ,"\t"}),
        ls.choice_node(1,{text("public"),text("protected"), text("private"), text("internal")}), text({" ",}), f(get_filename), text({ "()", "\t"}),
        text({ "{"  ,"\t\t"}),
        insert(0),
        text({ "", "\t}" }),
        text({ "", "}" }),
    }),
    ls.snippet("ctor",{
        text("public "),
        f(get_class_name),
        text("()", ""),
        text({ "{","\t"}),
        insert(0),
        text({ "","}"}),
    }),
    ls.snippet("inst", {
        text("private readonly "),
        insert(1, "Type"),
        text(" _"),
        f(makename,1),
        insert(2),
        text({";", ""}),
    })

},{key = "csharp"})

vim.diagnostic.config({
    virtual_text = true,
})
-- vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
--     pattern = {"COMMIT_EDITMSG"},
--     command = ":1norm! A",
-- })
vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
    pattern = {"*.cs","*.csproj", "*.targets"},
    command = "compiler dotnet",
})
vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
    pattern = {"*.cs","*.csproj","*.cshtml", "*.targets"},
    callback = function ()
        vim.keymap.set("n", "<localleader>r", function ()
            require("neotest").run.run()
        end , {})
        vim.keymap.set("n", "<localleader>R", function ()
            require("neotest").run.run(vim.fn.expand("%"))
        end, {})
        vim.keymap.set("n",  "<localleader>m", ":wa<Enter>:Make<Enter>")
        vim.keymap.set("n",  "<localleader>m", ":wa<Enter>:Make<Enter>")
        vim.keymap.set("n", "<localleader>w", [[:Start! iisexpress.exe /config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config /siteid:2<CR>]])
        vim.keymap.set("n", "<localleader>w", [[:Start! iisexpress.exe /config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config /siteid:2<CR>]])
        vim.keymap.set("n", "<localleader>e", [[:Start! iisexpress.exe /config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config /siteid:4<CR>]])
        -- vim.keymap.set("n", "<localleader>c", function()
        --     vim.cmd([[Start! jb.exe cleanupcode --settings="C:\Users\ELVHIL\fido\Sti.sln.DotSettings"]] .. vim.fn.expand("%"))
        -- end,{})
        vim.keymap.set("n", "<localleader>d", [[:Start! C:\Users\ELVHIL\fido\Fido.Import.DistribuerTilRaven\bin\Fido.Import.DistribuerTilRaven.exe]])
    end
})

vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
    pattern = {"http"},
    callback = function ()
        vim.keymap.set("n",  "<localleader>r", "<Plug>RestNvim")
        vim.keymap.set("n",  "<localleader>p",  "<Plug>RestNvimPreview")
        vim.keymap.set("n", "<localleader>w", [[:Start! iisexpress.exe /config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config /siteid:2<CR>]])
        vim.keymap.set("n", "<localleader>f", [[:Start! iisexpress.exe /config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config /siteid:4<CR>]])

    end
})
require('neogen').setup {
    enabled = true,
    languages = {
        cs = {
            template = {
                annotation_convention = "xmldoc" -- for a full list of annotation_conventions, see supported-languages below,
            }
        },
    }
}
