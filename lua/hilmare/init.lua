require("hilmare.packer")
require("hilmare.set")
require("hilmare.remap")
local ts_utils = require("nvim-treesitter.ts_utils")

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

        -- print(vim.inspect(vim.lsp.semantic_tokens.get_at_pos()))
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
    local text = vim.api.nvim_buf_get_text(bufnr, x, y, z, w, {})
    local to_replace = change_func(text)
    vim.api.nvim_buf_set_text(bufnr, x,y,z,w, to_replace)
end

function B()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",[[
(using_statement
    (variable_declaration
        (variable_declarator
            (equals_value_clause 
                (invocation_expression
                    (member_access_expression 
                        name:(identifier)@metode(#eq? @metode "OpenAsyncSession")
                        )))))
    body: (block 
        (expression_statement 
            (await_expression 
                (invocation_expression 
                    function: (member_access_expression 
                        expression: (identifier)
                        name: (identifier) @a(#eq? @a "StoreAsync")
                        ))))@expr)
    )@u
]])
    local set = {};
    for pattern, match, metadata in query:iter_matches(tree:root(),0) do
        local startLine,_,_,_ = match[4]:range()
        set[startLine] = match[3];
    end
    for key, value in pairs(set) do
        local linja = GetTextFromNode(value)[1];
        -- print(linja)
        local function change()
            return {linja .. "await session.SaveChangesAsync();"}
        end
        ReplaceTextInNode(value, change, 0)
    end

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

function AddNullCheck()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
        [[
(binary_expression 
    left: (member_access_expression
        expression:
        (identifier)@i 
        name: (identifier)@a(#eq? @a "GyldigTil")
        )
    right: (identifier)
    )@res
]])
    for _, matches, _ in query:iter_matches(tree:root(), 0) do
        local variable = matches[1]
        local binary = matches[3]
        local function thing(_)
            local text = GetTextFromNode(variable, 0)
            local text2 = GetTextFromNode(binary, 0)
            return { "("..text[1]..".GyldigTil == null || ".. text2[1] .. ")"}
        end
        ReplaceTextInNode(binary, thing, 0)
    end

end

local function client_positional_params(params)
  local win = vim.api.nvim_get_current_win()

    local ret = vim.lsp.util.make_position_params(win, vim.lsp.client.offset_encoding)
    if params then
      ret = vim.tbl_extend('force', ret, params)
    end
    return ret
end
local function get_type_from_hover_result(results)
    local type_definition
    for client_id, resp in pairs(results) do
        local err, result = resp.err, resp.result
        if err then
            vim.lsp.log.error(err.code, err.message)

        elseif result then
            local v = results[client_id]["result"]["contents"]["value"]
            local b = string.sub(v, 4, #v -3):reverse()
            local x = string.find(b, " ")
            type_definition = b:sub(x+1):reverse()

        end
    end
    vim.print(results)
    if type == "" then
        type_definition = vim.fn.input("Enter type:")
    end
    return type_definition
end
local function add_instance_property_under_node(node, type_identifier, name)
            local _, indent_count,_,_ = node:range()
            local indent = string.rep(" ", indent_count);
            ReplaceTextInNode(node, function (text)
                text[#text+1]=indent.."private readonly " .. type_identifier .. " _" ..name .. ";";
                return text
            end, 0)
end
local function add_parameter_to_constructor(parameter_list_node, parameter_before_node, type_identifier, name)
            local parameter_list = GetTextFromNode(parameter_list_node)
            if (#parameter_list > 1) then
                local _, indent_count, using_end_row,using_end_col = parameter_before_node:range()
                local indent = string.rep(" ", indent_count);
                vim.api.nvim_buf_set_text(0, using_end_row, using_end_col, using_end_row,using_end_col+1,{ ","})
                vim.api.nvim_buf_set_lines(0,using_end_row+1, using_end_row+1, false, {indent .. type_identifier .. " " .. name ..")"})
            else
                local _, _, using_end_col, using_end_row = parameter_before_node:range()
                vim.api.nvim_buf_set_text(0, using_end_col, using_end_row, using_end_col,using_end_row,{ ", " .. type_identifier .." ".. name })
            end
end
local function add_equals_expressions_after(node, type_identifier, name)
    local _, indent_count, using_end_row,_ = node:range()
            local indent = string.rep(" ", indent_count);
            vim.api.nvim_buf_set_lines(0,using_end_row+1, using_end_row+1, false, {indent .. "_".. name .. " = " .. name ..";"})
end
function AddInstanceProperty()
    vim.api.nvim_feedkeys("n","mZ",false)
    vim.lsp.buf_request_all(0, vim.lsp.protocol.Methods.textDocument_hover, client_positional_params(), function(results, ctx)
        local parser = vim.treesitter.get_parser(0,"c_sharp")
        local tree = parser:parse()[1]
        local query = vim.treesitter.query.parse("c_sharp",
            [[
(declaration_list
  (field_declaration) @last_property
    (constructor_declaration
        (parameter_list  (parameter)@last_parameter .)@parameter_list
        (block (_)? @last_expression .)))
]])
        -- TODO: Kan sjekke om 1 er større alfabetisk eller den siste som fallback
        local cursor_node = ts_utils.get_node_at_cursor()
        local type_identifier = get_type_from_hover_result(results);

        local name = GetTextFromNode(cursor_node)[1];
        for key, value, thing in query:iter_matches(tree:root(), 0) do
            add_instance_property_under_node(value[1], type_identifier, name);
            break
        end
        local last_parameter_node
        local last_parameter_list_node
        for key, value, thing in query:iter_captures(tree:root(), 0) do
            if key == 2 then
                last_parameter_node = value
            elseif key == 3 then
                last_parameter_list_node = value
            end
        end
        add_parameter_to_constructor(last_parameter_list_node, last_parameter_node, type_identifier, name)
        local last_assignment_node
        for key, value, thing in query:iter_captures(tree:root(), 0) do
            if key == 4 then
                last_assignment_node = value
            end
        end
        add_equals_expressions_after(last_assignment_node, type_identifier, name)
        -- TODO bruk go to definition, og om det er en parameter, gjør det vi gjør her,
        -- og om det er en statement, flytt 
        vim.lsp.buf.rename("_" ..name)
    end)
    vim.api.nvim_feedkeys("n","`Z",false)
end
function move_code_to_function()
    -- ask function name
    -- add function below
    -- list inputs
    -- select return value
    --
    -- get end of this function
    local _, ls, cs = unpack(vim.fn.getpos('v'))
    local _, le, ce = unpack(vim.fn.getpos('.'))
    -- spwap if wrong order
    local query_string = "(identifier)@id"

    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", query_string)
    vim.print(ls)
    vim.print(le)

    for i, value, _ in query:iter_captures(tree:root(), 0, ls, le) do
        vim.print(GetTextFromNode(value))
    end

end
vim.keymap.set("v", "øyf", move_code_to_function, {})

function iter_captures(query_string)
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", query_string)

    return query:iter_captures(tree:root(), 0)
end
function iter_matches(query_string)
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", query_string)

    return query:iter_matches(tree:root(), 0)
end
local function do_things_with_type_from_identifier(node, action)
    local t = client_positional_params()
    local x, y, _, _= node:range()
    t["position"]["character"] = y
    t["position"]["line"] = x
    vim.lsp.buf_request_all(0, vim.lsp.protocol.Methods.textDocument_hover, t, function(results, ctx)
        local type_identifier = get_type_from_hover_result(results);
        action(type_identifier)
    end)
end
function ReplaceVarWithType()
    vim.api.nvim_feedkeys("n","mZ",false)
    local matches = iter_matches(
        [[
        (variable_declaration
        type: (implicit_type) @var
        (variable_declarator name: (identifier) @name
            [(invocation_expression)
            (member_access_expression)
            (identifier)
            (binary_expression)
            (unary_expression)
            (await_expression)
            ]))
]])
    for i, match, _ in matches do
        do_things_with_type_from_identifier(match[2], function (type_identifier)
            ReplaceTextInNode(match[1], function (_)
                return { type_identifier }
            end)
        end)

    end
    vim.api.nvim_feedkeys("n","`Z",false)
end

vim.keymap.set("n", "øi", AddInstanceProperty, {})
vim.keymap.set("n", "øt", ReplaceVarWithType, {})
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
function CreateMarkdownTable()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
        [[
    body: (declaration_list 
        (record_declaration 
            (modifier) 
            name: (identifier) 
            body: (declaration_list 
                (comment) @a(#eq? @a "/// <summary>")
                (comment)* @comments
                (comment) @b(#eq? @b "/// </summary>")
                [
                    (property_declaration 
                        (modifier)@single
                        type: (_) @type
                        name: (_) @property )
                    (property_declaration
                        (modifier)
                        (modifier)
                        type: (_) @type
                        name: (_) @property )
                )@declaration))
]])
    local text = {'|Property|Type|Required|Description|',
        '|--------|----|--------|-----------|'
    };
    local tabell
    local types = {}
    local names = {}
    local comments = {}
    local publics = {}
    local requireds = {}
    for t, capture, metadata in query:iter_captures(tree:root(), 0) do


        local isPublic = false
        local name = query.captures[t];
        -- print(t)
        -- print(name .. GetTextFromNode(node, 0)[1])
        if name =="comments" then
            vim.print(GetTextFromNode(capture)[1])
            table.insert(comments,1, capture)
        elseif name == "type" then
            table.insert(types,1, capture)
        elseif name == "property" then
            table.insert(names,1, capture)
        else
            -- print(name)
        end
    end
    -- vim.print(comments)

    -- for t, match, metadata in query:iter_matches(tree:root(), 0) do
    --     local isPublic = false
    --     local property = ""
    --     local type = ""
    --     local required = ""
    --     local comments = ""
    --     for id, node in pairs(match) do
    --         local name = query.captures[id]
    --         if name ~= nil then
    --             -- print(name .. GetTextFromNode(node, 0)[1])
    --             if name =="comments" then
    --                 comments = comments .. GetTextFromNode(node, 0)[1]
    --             elseif name == "modifier" then
    --                 local modifier = GetTextFromNode(node, 0)[1]
    --                 if modifier == "required" then
    --                     required = modifier
    --                 end
    --                 if modifier == "public" then
    --                     isPublic = true
    --                 end
    --             elseif name == "type" then
    --                 type = GetTextFromNode(node,0)[1]
    --             elseif name == "property" then
    --                 property = GetTextFromNode(node,0)[1]
    --             end
    --         end
    --     end
    --     -- local first_comment = table.concat(GetTextFromNode(match[1], 0))
    --     -- local description = table.concat(GetTextFromNode(match[1], 0))
    --     -- local last_comment = table.concat(GetTextFromNode(match[2], 0))
    --     -- local modifier = table.concat(GetTextFromNode(match[3], 0))
    --     -- local smth = GetTextFromNode(match[4], 0)[1]
    --     -- local type = table.concat(GetTextFromNode(match[5], 0))
    --     -- local name = table.concat(GetTextFromNode(match[6], 0))


    --     table.insert(text, t+2,
    --         ' | '.. property ..
    --         ' | ' .. type ..
    --         ' | ' .. required ..
    --         ' | ' .. comments ..
    --         '|')

    -- end
end
function DoAsyncSessionStuff(parser)
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
        [[
   (using_statement
       (variable_declaration
           (variable_declarator
               (equals_value_clause
                   (invocation_expression
                       (member_access_expression
                           (member_access_expression
                               (identifier)@expr . 
                               (identifier)@name
                               (#eq?@name "DocumentStore"))))@asyncSession)))
       (block
           (expression_statement
               (invocation_expression
                   (member_access_expression name:
                       (identifier)@func
                       (#any-of? @func "Store" "SaveChanges"))@awaither))))@using
]])
    for t, capture, _ in query:iter_captures(tree:root(), 0) do
        local start_row, start_col, stop_row, stop_col= capture:range()
        --asyncSession change to documentStore.OpenAsyncSession
        if(t == 3) then
            vim.api.nvim_buf_set_text(0,start_row, start_col, stop_row, stop_col, {"documentStore.OpenAsyncSession();"})
        end
        if(t == 5) then
            local text = GetTextFromNode(capture, 0)
            vim.api.nvim_buf_set_text(0,start_row, start_col, stop_row, stop_col, {"await ".. text[1] .."Async"})
        end
    end
    --glemmer for loops med store i seg
end
function ContainsToIn()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp",
        [[
    (invocation_expression 
        function: (member_access_expression 
            name: (identifier)@id(#eq? @id "Any")
            )
        arguments: (argument_list
            (argument
                (lambda_expression 
                    body: (invocation_expression
                        function: (member_access_expression
                            expression:(_)@target
                            name: (identifier)@any(#eq? @any "Contains")
                            )
                        (argument_list(argument))
                        ))))@args2
        )
    ]])
    for t, capture, _ in query:iter_matches(tree:root(), 0) do
        local anyNode = capture[1]
        local argumentsNode = capture[4]
        local targetNode = capture[2]
        local start_col, start_row, _,_ = anyNode:range()
        local _,_,end_col, end_row = argumentsNode:range()
        local newCode = "ContainsAny(" .. GetTextFromNode(targetNode, 0)[1] ..")"
        vim.api.nvim_buf_set_text(0, start_col, start_row, end_col, end_row, {newCode})
        -- print(newCode)
    end

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

function remove_async()
    local ts_opts = {}
    ts_opts["bufnr"] = 0
    ts_opts["pos"] = nil
    local node = vim.treesitter.get_node(ts_opts)
    if not node then
        return nil
    end
    local next = node
    while next do
        if next:type() == "method_declaration" then
            local x, y, w, z = next:range()
            local range = {x,y,w,z}
            local parser = vim.treesitter.get_parser(0,"c_sharp")
            -- kanskje slette range
            local tree = parser:parse()[1]
            local query = vim.treesitter.query.parse("c_sharp", [[
        (method_declaration 
            (modifier)?@mod(#eq? @mod "async")
            returns:[(identifier)@task
                (generic_name
                    (identifier)
                    (type_argument_list((_)@generic)))@generic_task]

            name: (_)@name)
        ]])
            for i, match, metadata in query:iter_matches(next,0) do
                local async = match[1]
                local task = match[2]
                local generic = match[3]
                local generic_task = match[4]
                local name = match[5]

                ReplaceTextInNode(name, function (text)
                    local subbedText = text[1]:sub(-5,-1)
                    -- print(subbedText)
                    if (subbedText == "Async") then
                        return { text[1]:sub(1, -6)}
                    else
                        return { text[1] }
                    end
                end, 0)
                if task ~= nil then
                    local function void()
                        return {"void"}
                    end
                    ReplaceTextInNode(task, void, 0)
                elseif generic_task ~=nil then
                    --TODO: kan matche generic_name og gjøre det skikkelig, men også
                    --ikke

                    local function void()
                        return {GetTextFromNode(generic)[1]}
                    end
                    ReplaceTextInNode(generic_task, void, 0)
                end
                if async ~= nil then
                    local x1, y1, z1, w1 = async:range()
                    vim.api.nvim_buf_set_text(0, x1,y1-1,z1,w1,{""})
                end
            end
            return
        else
            local tmp = next:parent()
            if next ~= nil then 
                next = tmp
            else
                return
            end
        end
    end
end

local function wrap_query(query, nodes)
    local ret  = "["
    for _, node in pairs(nodes) do
        ret = ret .. "(" .. node .." ".. query .. ") "
    end
    ret  = ret .. "]"
    return ret
end
function remove_async_from_methodname()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    -- kanskje slette range
    local tree = parser:parse()[1]
    local inner_query = [[
        (invocation_expression 
            function:  [
                (identifier) @c(#match? @c ".*Async$")
                (member_access_expression 
                    name: [
                        (generic_name
                            (identifier)@b(#match? @b ".*Async$"))
                        (identifier)@b(#match? @b ".*Async$")
                    ])])
    ]]
    local nodes = {
        "variable_declarator",
        "return_statement",
        "if_statement",
        "expression_statement",
        "parenthesized_expression",
        "lambda_expression",
        "assignment_expression"
    }
    vim.print(wrap_query(inner_query, nodes))
    local query = vim.treesitter.query.parse("c_sharp", wrap_query(inner_query, nodes))
    for i, match, metadata in query:iter_matches(tree:root(),0) do
        local the_node
        for j,node in pairs(match) do
            if node ~= nil then
                vim.print(GetTextFromNode(node)[1])
                the_node = node
            end
        end

        -- vim.print(GetTextFromNode(the_node))
        ReplaceTextInNode(the_node, function (text)
            return { text[1]:sub(1, -6)}
        end,0)
    end
end
function remove_async_from_methodname_definition()
    local parser = vim.treesitter.get_parser(0,"c_sharp")
    -- kanskje slette range
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", [[
    (method_declaration
        returns: [(predefined_type)@predefined
            (identifier)@identifier
            (generic_name)@generic_name
        ]
        name: (identifier)@name(#match? @name ".*Async$"))
    ]])
    for i, match, metadata in query:iter_matches(tree:root(),0) do
        local predefined = match[1]
        local identifier = match[2]
        local generic = match[3]
        if predefined ~= nil then -- er de en predefined type, er det ikke en task som returneres
            ReplaceTextInNode(match[4], function (text)
                return { text[1]:sub(1, -6)}
            end,0)
        elseif identifier ~= nil and GetTextFromNode(identifier)[1] ~= "Task" then
            ReplaceTextInNode(match[4], function (text)
                return { text[1]:sub(1, -6)}
            end,0)
        elseif generic ~= nil and GetTextFromNode(generic)[1]:sub(1,4) ~= "Task" then
            print(GetTextFromNode(generic)[1]:sub(1,5))
            ReplaceTextInNode(match[4], function (text)
                return { text[1]:sub(1, -6)}
            end,0)
        end
    end
end
function add_async()
    local ts_opts = {}
    ts_opts["bufnr"] = 0
    ts_opts["pos"] = nil
    local node = vim.treesitter.get_node(ts_opts)
    if not node then
        return nil
    end
    local next = node
    while next do
        if next:type() == "method_declaration" then
            local x, y, w, z = next:range()
            local range = {x,y,w,z}
            local parser = vim.treesitter.get_parser(0,"c_sharp")
            -- kanskje slette range
            local tree = parser:parse()[1]
            local query = vim.treesitter.query.parse("c_sharp", [[
      (method_declaration 
          returns: [(predefined_type)@void
              (identifier)@identifier
              (generic_name)@generic
              (nullable_type)@nullable
          ]
          name: (identifier)@name)
      ]])
            for i, match, metadata in query:iter_matches(next,0) do
                local predefined = match[1]
                local identifier = match[2]
                local generic = match[3]
                local nullable = match[4]
                local name = match[5]

                local function add_async_task(t)
                        return { "async Task<" .. t[1] ..">" }
                end
                ReplaceTextInNode(name, function (text)
                    local subbedText = text[1]:sub(-5,-1)
                    -- print(subbedText)
                    if (subbedText == "Async") then
                        return { text[1]}
                    else
                        return { text[1] .. "Async" }
                    end
                end, 0)

                if predefined ~= nil then
                    local text = GetTextFromNode(predefined)[1]
                    if text == "void" then
                        local function task()
                            return { "async Task" }
                        end
                        ReplaceTextInNode(predefined, task)
                    else
                        ReplaceTextInNode(predefined, add_async_task)
                    end

                elseif identifier ~= nil then
                    ReplaceTextInNode(identifier, add_async_task)
                elseif generic ~= nil then
                    local text = GetTextFromNode(generic)[1]
                    local subbedText = text:sub(1,4)
                    if (subbedText ~= "Task") then
                        ReplaceTextInNode(generic, add_async_task)
                    else
                        local function task(t)
                            return { "async ".. t[1]}
                        end
                        ReplaceTextInNode(generic, task)
                    end
                elseif nullable ~= nil then
                    ReplaceTextInNode(nullable, add_async_task)
                end
            end
            return
        else
            local tmp = next:parent()
            if next ~= nil then
                next = tmp
            else
                return
            end
        end
    end
end

vim.keymap.set("n", "øyr", remove_async, {})
vim.keymap.set("n", "øya", add_async, {})
vim.keymap.set("v", "øe", encode, {})
vim.keymap.set("v", "ød", decode, {})
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
