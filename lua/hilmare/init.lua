require("hilmare.packer")
require("hilmare.set")
require("hilmare.remap")

function MoveL()
    local opts = {}
    opts["bufnr"] = 0
    opts["pos"] = nil

    local node = vim.treesitter.get_node(opts)
    if node ~= nil then
        local next = node:named_child(0)
        if (next == nil) then
            next = node:next_named_sibling()
            local tmp = node
            while (next == nil) do
                local p = tmp:parent()
                if (p == nil) then
                    next = node
                else
                    next = p:next_named_sibling()
                    tmp = p
                end
            end
        end

        local row, col, _ = next:start()
        vim.api.nvim_win_set_cursor(0,{row+1,col})
    end

end
function MoveJ()
    local opts = {}
    opts["bufnr"] = 0
    opts["pos"] = nil

    local node = vim.treesitter.get_node(opts)
    if node ~= nil then
        local next = node:next_named_sibling()
        if (next == nil) then
            local tmp = node
            while (next == nil) do
                local p = tmp:parent()
                if (p == nil)then
                    next = node
                else
                    next = p:next_named_sibling()
                    tmp = p
                end
            end
        end

        local row, col, _ = next:start()
        vim.api.nvim_win_set_cursor(0,{row+1,col})

    end
end
function ConfigureAwaitFalse()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", [[
    (await_expression
    (invocation_expression
    [(member_access_expression
    (identifier)@identifier
    )
    (identifier)@identifier
    ]
    )
    )@await]])
    -- local query = vim.treesitter.query.parse("c_sharp",[[
    -- (await_expression
    --     (invocation_expression

    --         name: identifier @ function
    --         )@await)]])
    local iter = query:iter_matches(tree:root(),0)
    for id, capture, hei in iter do
        if (capture[1] ~= "ConfigureAwait") then
            local _, _, row,col = capture[2]:range()
            vim.api.nvim_buf_set_text(0,row,col,row,col,{".ConfigureAwait(false)"})
        end

        -- local val2 = capture[id+1]
        -- print(val)
    end
    -- local _, capture, _ =  iter()
    -- print(capture)
    -- local _, _, row,column = capture:range()
    -- print("hei")
    -- vim.api.nvim_buf_set_text(0,row,column,row,column,{".ConfigureAwait(false)"})
end
function GetTextFromNode(node, bufnr)
    if not bufnr then
        bufnr = 0
    end
    local x, y, z, w = node:range()
    return vim.api.nvim_buf_get_text(bufnr, x, y, z,w, {})
end

function ReplaceTextInNode(node, change_func, bufnr)
    if not bufnr then
        bufnr = 0
    end
    local x, y, z, w = node:range()
    local text = vim.api.nvim_buf_get_text(bufnr, x, y, z,w, {})
    local to_replace = change_func(text)
    vim.api.nvim_buf_set_text(bufnr, x,y,z,w, to_replace)
end

function UsingDocumentStore()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",[[
    (block
    (local_declaration_statement(variable_declaration(variable_declarator(equals_value_clause(invocation_expression(identifier)@identifier))))@declaration)@to_replace
    )@block
    ]])
    for pattern, match, metadata in query:iter_matches(tree:root(),0) do
        local declaration = match[2]
        local x,y,z,w = match[1]:range()
        local text2 = vim.api.nvim_buf_get_text(0, x, y, z,w, {})
        if text2[1] == "CreateDocumentStore" then
            local to_replace = match[3]
            local block = match[4]
            local text = GetTextFromNode(declaration, 0)
            local function change()
                return {"using("..text[1] .."){"}
            end
            ReplaceTextInNode(to_replace, change, 0)
            local _, _, using_end_col, using_end_row = block:range()
            vim.api.nvim_buf_set_text(0, using_end_col, using_end_row-1, using_end_col,using_end_row,{ "}}"})
            -- end
        end
    end
    -- for id, node, metadata  in query:iter_captures(tree:root(),0) do
    --     -- if id == 1 then
    --     print("----")
    --     print(id)
    --     print(vim.inspect(node))
    --     local start_col, start_row, end_col, end_row = node:range()
    --     local text = vim.api.nvim_buf_get_text(0, start_col, start_row, end_col,end_row, {})
    --     print(vim.inspect(text))
    --     print(vim.inspect(metadata))
    --     -- for child in node:iter_children() do
    --     --     print(child)
    --     -- end
    -- -- end
    -- end


end
function Compose2()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
    [[ (invocation_expression
    function:(identifier)@id
    )
    ]])


    for _, capture, _ in query:iter_captures(tree:root(), 0) do
        local text = GetTextFromNode(capture, 0)
        -- if text[1] == "CreateDocumentStore" or CreateTestData or WaitForIndexing or then
        --     local function thing(_)
        --         return { "_ravenTestClass." .. text[1] }
        --     end
        --     ReplaceTextInNode(capture, thing, 0)
        -- end
    end
end
function ComposeRavenTestClass()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",[[
    (class_declaration
    (base_list
    (identifier)@base)@liste
    (declaration_list)@dec_list)
    ]])
    for _, matches, _ in query:iter_matches(tree:root(),0) do
        local t = GetTextFromNode(matches[1],0)
        print(vim.inspect(t))
        if t[1] == "RavenTestClassBase" then
            local function remove(_)
                return {}
            end
            ReplaceTextInNode(matches[2], remove, 0)

            local text=GetTextFromNode(matches[3], 0)
            local function insert_testclass(_)
                 table.insert(text,2, "private static readonly RavenTestClassBase _ravenTestClass = new RavenTestClassBase();")
                 print(text)
                 return text

            end
            ReplaceTextInNode(matches[3], insert_testclass, 0)

        end
    end
end
function GetTestMethods()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",[[
    (class_declaration
    (attribute_list
    (attribute
    (identifier)@class_attribute(#match?@class_attribute "^TestClass$")
    )
    )
    (attribute_list)*
    .
    (modifier)@class_modifier
    .
    (identifier)
    (declaration_list
    (method_declaration
    (modifier)@method_modifier (#not-eq?@method_modifier "static")
    .
    type: (_)
    )@method
    )
    )
    ;; put the cursor under the capture to highlight the matches.
    ]])
    local first_class_found = false
    for i, j, _ in query:iter_captures(tree:root(),0) do
        local text = GetTextFromNode(j, 0)
        local function replace()
            return { text[1] .. " static"}
        end
        if (i == 2 and not first_class_found) then
            first_class_found = true
            ReplaceTextInNode(j, replace, 0)
        end
        if (i == 3) then
            ReplaceTextInNode(j, replace, 0)
        end
    end
    -- for _, match, _ in query:iter_matches(tree:root(), 0) do
    --     print(vim.inspect(GetTextFromNode(match[1])))
    --     print(vim.inspect(GetTextFromNode(match[2])))
    --     print(vim.inspect(GetTextFromNode(match[3])))
    --     ReplaceTextInNode(match[3], function ()
        --         return {"public static"}
        --     end, 0)

        -- end
    end

    function DeleteUsings()
        local parser = vim.treesitter.get_parser(0,"c_sharp")
        local tree = parser:parse()[1]
        local query = vim.treesitter.query.parse_query("c_sharp",'(using_statement (block))@using')
        local iter = query:iter_captures(tree:root(),0)
        local id, capture, metadata =  iter()
        if (capture == nil) then
            return
        end
        local child_count = capture:child_count()

        local block = capture:child(child_count-1)
        -- print(child_count)
        -- for child in block:iter_children() do
        --     print(child)
        -- end


        local block_first_child = block:child(1)
        local block_last_child = block:child(block:child_count()-2)
        local block_inner_start_row, block_inner_start_column, _ = block_first_child:start()
        local block_inner_end_row, block_inner_end_column, _ = block_last_child:end_()
        -- print(block_inner_end_row, block_last_child)

        local using_start_row, using_start_column = capture:start()
        local using_end_row, using_end_column = capture:end_()


        local bufnr = vim.api.nvim_get_current_buf()
        local text = vim.api.nvim_buf_get_text(bufnr, block_inner_start_row, block_inner_start_column, block_inner_end_row,block_inner_end_column, {})
        vim.api.nvim_buf_set_text(bufnr,using_start_row,using_start_column, using_end_row, using_end_column, text)

        -- print(vim.inspect(capture))
        -- print(vim.inspect(metadata))
    end
    vim.ui.select = function(items, opts, on_choice)
        vim.validate({
            items = { items, 'table', false },
            on_choice = { on_choice, 'function', false },
        })
        opts = opts or {}
        local choices = { opts.prompt.."\n" or 'Select one of:\n' }
        local format_item = opts.format_item or tostring
        local input_letters = {"a","s","d","f","g","h","j","k","l","ø","aa","as","ad","af","ag","ah","aj","ak","al","aø"}
        for i, item in pairs(items) do
            table.insert(choices, string.format('[ %s ]: %s\n', input_letters[i], format_item(item)))
        end
        table.insert(choices, " >")
        local letter
        local on_confirm= function(input)
            letter = input
        end
        vim.ui.input({prompt = table.concat(choices)}, on_confirm)
        local choice = 0
        for k, v in pairs(input_letters) do
            if letter == v then
                choice = k
            end
        end
        if choice < 1 or choice > #items then
            on_choice(nil, nil)
        else
            on_choice(items[choice], choice)
        end
    end

