require("hilmare.packer")
require("hilmare.set")
require("hilmare.remap")

-- function SendRequest()
--     local lspclient = vim.lsp.get_clients({name = "roslyn"})
--     function handler(err, result, ctx, config)
--         print(err)
--         print(result)
--         print(ctx)
--         print(config)
--     end
--     vim.lsp.buf_request_all(0,"textDocument/definition",
--     {
--         DocumentUri=
--     },
--     handler)
--     print(vim.pretty_print(lspclient))
-- end

-- SendRequest()



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
function Find()
    vim.lsp.semantic_tokens.start(0,1,nil)
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", [[
    (binary_expression(null_literal))@hei
    ]])
    local iter = query:iter_matches(tree:root(),0)
    for id, capture, hei in iter do
        local row, col,_,_ = capture[1]:range()
        vim.api.nvim_win_set_cursor(0,{row+1,col})

        print(vim.inspect(vim.lsp.semantic_tokens.get_at_pos()))
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
    end
    -- local _, capture, _ =  iter()
    -- local _, _, row,column = capture:range()
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

function DoChanges()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    DoAsyncSessionStuff(parser)
    RemoveClassCleanup(parser)
    RemoveClassInitialize(parser)
    AddBaseClass(parser)
    ReplaceTestData(parser)
    WaitForIndexingAfterSaveChanges(parser)
end
--Finne alle klasser som har en session fra ravenTestContextFactory
function RemoveClassCleanup(parser)
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
    [[
(method_declaration(attribute_list(attribute(identifier)@id(#match?@id "^ClassCleanup$")))(block . (expression_statement) . ))@method
 ]])
    for t, capture, _ in query:iter_captures(tree:root(), 0) do
        if(t == 2) then
            local start, _, stop, _ = capture:range()
            vim.api.nvim_buf_set_lines(0,start, stop+1, false, {})
        end
    end
end
function RemoveClassInitialize(parser)
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
    [[
(method_declaration(attribute_list(attribute(identifier)@id(#match?@id "^ClassInitialize$")))(block . (expression_statement) . ))@method
 ]])
    for t, capture, _ in query:iter_captures(tree:root(), 0) do
        if(t == 2) then
            local start, _, stop, _ = capture:range()
            vim.api.nvim_buf_set_lines(0,start, stop+1, false, {})
        end
    end
end
function AddBaseClass(parser)
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
    [[
(class_declaration(attribute_list(attribute(identifier)@attributeName(#match?@attributeName "TestClass")))(identifier)@className(declaration_list(field_declaration(variable_declaration(variable_declarator(identifier)@variableName(#match?@variableName "ravenTestContextFactory"))))@field))@class
 ]])
    for t, capture, _ in query:iter_captures(tree:root(), 0) do
        if(t == 2) then
            local _,_,stop_col, stop_row  = capture:range()
            vim.api.nvim_buf_set_text(0,stop_col, stop_row, stop_col, stop_row, {" : RavenTestClassBase"})
        end
        if(t == 4) then

            local start, _, stop, _ = capture:range()
            vim.api.nvim_buf_set_lines(0,start, stop+1, false, {})
        end
    end
end
function ReplaceTestData(parser)
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
    [[
(variable_declarator(equals_value_clause(invocation_expression(member_access_expression expression: (identifier)@expr(#eq?@expr "ravenTestContextFactory") name: (identifier)@id(#eq? "Create" @id))@replace)))
 ]])
    for t, capture, _ in query:iter_captures(tree:root(), 0) do
        if(t == 3) then
            local start_row, start_col, stop_row, stop_col= capture:range()
            vim.api.nvim_buf_set_text(0,start_row, start_col, stop_row, stop_col, {"CreateTestData"})
            vim.api.nvim_buf_set_lines(0,stop_row+1, stop_row+1,false, {"\t\t\tvar documentStore = CreateDocumentStore();"})
        end
    end
end
--

function DoAsyncSessionStuff(parser)
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
    [[
(using_statement(variable_declaration(variable_declarator(equals_value_clause(invocation_expression(member_access_expression(member_access_expression(identifier)@expr . (identifier)@name(#eq?@name "DocumentStore"))))@asyncSession)))(block(expression_statement(invocation_expression(member_access_expression name:(identifier)@func(#any-of? @func "Store" "SaveChanges"))@awaither))))@using
 ]])
    for t, capture, _ in query:iter_captures(tree:root(), 0) do
        local start_row, start_col, stop_row, stop_col= capture:range()
        --asyncSession change to documentStore.OpenAsyncSession
        if(t == 3) then
            vim.api.nvim_buf_set_text(0,start_row, start_col, stop_row, stop_col, {"documentStore.OpenAsyncSession()"})
        end
        if(t == 5) then
            local text = GetTextFromNode(capture, 0)
            vim.api.nvim_buf_set_text(0,start_row, start_col, stop_row, stop_col, {"await ".. text[1] .."Async"})
        end
    end
    --glemmer for loops med store i seg
end
function WaitForIndexingAfterSaveChanges(parser)
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
    [[
(block(expression_statement(await_expression(invocation_expression(member_access_expression name:(identifier)@func(#eq? @func "SaveChangesAsync"))@wait_here))))
 ]])
    for t, capture, _ in query:iter_captures(tree:root(), 0) do
        local start_row, start_col, stop_row, stop_col= capture:range()
        --await_here add await at beginning
        --asyncSession change to documentStore.OpenAsyncSession
        if(t == 2) then
            local text = GetTextFromNode(capture, 0)
            vim.api.nvim_buf_set_lines(0,stop_row+1, stop_row+1, false, {"WaitForIndexing(documentStore)"})
        end
    end
end
--
-- Bytte  om Raven2 => Raven5
-- 
-- id problemer.
-- dictionary problemer.
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
        if text[1] == "CreateDocumentStore" or text[1] =="CreateTestData" or text[1] == "WaitForIndexing1" or text[1] == "WaitForUserToContiueTest" then
            local function thing(_)
                return { "_ravenTestClass." .. text[1] }
            end
            ReplaceTextInNode(capture, thing, 0)
        end
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
        if t[1] == "RavenTestClassBase" then
            local function remove(_)
                return {}
            end
            ReplaceTextInNode(matches[2], remove, 0)

            local text=GetTextFromNode(matches[3], 0)
            local function insert_testclass(_)
                 table.insert(text,2, "private static readonly RavenTestClassBase _ravenTestClass = new RavenTestClassBase();")
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

    function Base64encodeSelection()

        local vstart = vim.fn.getpos("'<")

        local vend = vim.fn.getpos("'>")
        if not vstart or not vend then
            return
        end
        -- or use api.nvim_buf_get_lines
        local lines = vim.api.nvim_buf_get_text(0, vstart[1],vstart[2],vend[1],vend[2])
        return lines
    end
    function decode()
        local _, ls, cs = unpack(vim.fn.getpos('v'))
        local _, le, ce = unpack(vim.fn.getpos('.'))
        -- spwap if wrong order
        local text = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
        local concatted = table.concat(text, "")
        local stripped = concatted:match( "^%s*(.-)%s*$" )
        local decoded = vim.base64.decode(stripped)
        vim.api.nvim_buf_set_text(0, ls-1, cs-1, le-1, ce, Split(decoded, "\n"))

    end
    function encode()
        local _, ls, cs = unpack(vim.fn.getpos('v'))
        local _, le, ce = unpack(vim.fn.getpos('.'))
        -- spwap if wrong order
        local text = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
        local concatted = table.concat(text, "\n")
        local encoded = vim.base64.encode(concatted)
        vim.api.nvim_buf_set_text(0, ls-1, cs-1, le-1, ce, {encoded})
        vim.api.nvim_feedkeys("v","v",false)

    end
    vim.keymap.set("v", "øe", encode, {})
    vim.keymap.set("v", "ød", decode, {})

    local l = "heisann"
    function Split(string, inSplitPattern )

        local outResults = {}
        local theStart = 1
        local theSplitStart, theSplitEnd = string.find( string, inSplitPattern, theStart )

        while theSplitStart do
            table.insert( outResults, string.sub( string, theStart, theSplitStart-1 ) )
            theStart = theSplitEnd + 1
            theSplitStart, theSplitEnd = string.find( string, inSplitPattern, theStart )
        end

        table.insert( outResults, string.sub( string, theStart ) )
        return outResults
    end
