local ts_utils = require("hilmare.treesitter-utils")

local function get_parser_and_tree()
    local parser = vim.treesitter.get_parser(0, "python")
    return parser, parser:parse()[1]
end

local function execute_ts_query(query_string, handler)
    local parser, tree = get_parser_and_tree()
    local query = vim.treesitter.query.parse("python", query_string)
    for id, capture, metadata in query:iter_matches(tree:root(), 0) do
        handler(id, capture, metadata)
    end
end

local function request_hover(node, callback)
    local params = vim.lsp.util.make_position_params()
    local row, col, _, _ = node:range()
    params.position.line = row
    params.position.character = col
    vim.lsp.buf_request_all(0, vim.lsp.protocol.Methods.textDocument_hover, params, callback)
end

local function extract_type_from_hover(results)
    for _, resp in pairs(results) do
        if resp.result and resp.result.contents and resp.result.contents.value then
            local value = resp.result.contents.value
            local type_match = value:match("```python[%s%S]*%-%-%-%s*([%w%[%]%.%,%s]+)")
            if type_match then
                return type_match:gsub("^%s*(.-)%s*$", "%1")
            end
        end
    end
    return vim.fn.input("Enter type: ")
end

local M = {}

function M.add_type_hints()
    local query = [[
    (function_definition
        name: (identifier) @func_name
        parameters: (parameters
            (identifier) @param
        )?
    ) @function
    ]]
    
    execute_ts_query(query, function(id, capture, metadata)
        local param_node = capture[2]
        if param_node then
            request_hover(param_node, function(results)
                local type_hint = extract_type_from_hover(results)
                if type_hint and type_hint ~= "" then
                    local _, _, row, col = param_node:range()
                    local param_text = ts_utils.get_text_from_node(param_node, 0)[1]
                    vim.api.nvim_buf_set_text(0, row, col + #param_text, row, col + #param_text, {": " .. type_hint})
                end
            end)
        end
    end)
end

function M.convert_to_fstring()
    local query = [[
    (call
        function: (attribute
            object: (string) @string
            attribute: (identifier) @method (#eq? @method "format")
        )
        arguments: (argument_list) @args
    ) @format_call
    ]]
    
    for _, matches in ts_utils.iter_matches(query) do
        local string_node = matches[1]
        local format_call = matches[4]
        
        ts_utils.replace_text_in_node(format_call, function(_)
            local string_text = ts_utils.get_text_from_node(string_node, 0)[1]
            local fstring = string_text:gsub("'{(.-)}'", "{%1}")
            return {"f" .. fstring}
        end, 0)
    end
end

function M.sort_imports()
    local imports = {}
    local query = [[
    (import_statement) @import
    (import_from_statement) @from_import
    ]]
    
    execute_ts_query(query, function(id, capture)
        local import_node = capture[1]
        local import_text = ts_utils.get_text_from_node(import_node, 0)[1]
        table.insert(imports, {text = import_text, node = import_node})
    end)
    
    table.sort(imports, function(a, b) return a.text < b.text end)
    
    for i, import in ipairs(imports) do
        if i == 1 then
            local row, col, end_row, end_col = import.node:range()
            vim.api.nvim_buf_set_text(0, row, col, end_row, end_col, {import.text})
        end
    end
end

function M.add_docstring()
    local query = [[
    (function_definition
        name: (identifier) @func_name
        body: (block) @body
    ) @function
    ]]
    
    execute_ts_query(query, function(id, capture)
        print(capture)
        print(capture[1]:type(), capture[2]:type())
        local func_name = ts_utils.get_text_from_node(capture[1], 0)[1]
        local body_node = capture[2]
        
        local first_stmt = body_node:child(0)
        if first_stmt and first_stmt:type() == "expression_statement" then
            local expr = first_stmt:child(0)
            if expr and expr:type() == "string" then
                return
            end
        end
        
        local _, _, row, col = body_node:range()
        local docstring = string.format('    """%s function."""', func_name)
        vim.api.nvim_buf_set_text(0, row, col, row, col, {"\n" .. docstring .. "\n"})
    end)
end

function M.get_type_from_hover_result(results)
    return extract_type_from_hover(results)
end

function M.goto_first_argument()
    print("Going to first argument in the argument list")
    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    cursor_row = cursor_row - 1  -- Convert to 0-indexed
    
    local parser, tree = get_parser_and_tree()
    local node = tree:root():descendant_for_range(cursor_row, cursor_col, cursor_row, cursor_col)
    local function_node = node
    while function_node do
        print(function_node)
        local function_type = function_node:type() 
        if function_type == "call" or function_type == "method" then
            break
        end
        function_node = function_node:parent()
    end
    node = function_node
    print(node)

    
    -- Traverse down the tree to find an parameters node
    local function traverse_down(n)
        if n:type() == "argument_list" then
            -- Find the first argument in the argument list
            for child in n:iter_children() do
                if child:type() ~= "(" and child:type() ~= ")" and child:type() ~= "," then
                    local start_row, start_col = child:range()
                    vim.api.nvim_win_set_cursor(0, {start_row + 1, start_col})
                    return true
                end
            end
        end
        
        for child in n:iter_children() do
            if traverse_down(child) then
                return true
            end
        end
        return false
    end
    
    traverse_down(node)
    
    print("No argument list found at cursor position")
end

function M.goto_first_parameter()
    print("Going to first parameter in the paramaeter list")
    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    cursor_row = cursor_row - 1  -- Convert to 0-indexed
    
    local parser, tree = get_parser_and_tree()
    local node = tree:root():descendant_for_range(cursor_row, cursor_col, cursor_row, cursor_col)
    local function_node = node
    while function_node do
        print(function_node)
        local function_type = function_node:type() 
        if function_type == "function_definition" or function_type == "method_definition" then
            break
        end
        function_node = function_node:parent()
    end
    node = function_node
    print(node)

    
    -- Traverse down the tree to find an parameters node
    local function traverse_down(n)
        if n:type() == "parameters" then
            -- Find the first argument in the argument list
            for child in n:iter_children() do
                if child:type() ~= "(" and child:type() ~= ")" and child:type() ~= "," then
                    local start_row, start_col = child:range()
                    vim.api.nvim_win_set_cursor(0, {start_row + 1, start_col})
                    return true
                end
            end
        end
        
        for child in n:iter_children() do
            if traverse_down(child) then
                return true
            end
        end
        return false
    end
    
    traverse_down(node)
    
    print("No argument list found at cursor position")
end
function M.move_node_out()
    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    cursor_row = cursor_row - 1  -- Convert to 0-indexed
    
    local parser, tree = get_parser_and_tree()
    local node = tree:root():descendant_for_range(cursor_row, cursor_col, cursor_row, cursor_col)
    -- make current node a sibling of its parent
    print(node)
    local parent = node:parent()
    if not parent then
        print("No parent node found")
        return
            end
    print(parent)
    -- Get text of the node
    local node_text = ts_utils.get_text_from_node(node, 0)[1]
    print(node_text)
    -- Remove the node from its parent
    local node_start_row, node_start_col, node_end_row, node_end_col = node:range()
    vim.api.nvim_buf_set_text(0, node_start_row, node_start_col, node_end_row, node_end_col, {})
    -- Insert the node text at the end of the parent node
    vim.api.nvim_buf_set_text(0, node_start_row, node_start_col, node_start_row, node_start_col, {node_text})
    
end
F = M.move_node_out

function move_node(node, row, col)
    --get the current position of the node
    local start_row, start_col, end_row, end_col = node:range()
    -- if the start row and start col is after the node, subtract the ragnge from those
    -- values
    if start_row > row or (start_row == row and start_col > col) then
        row = row - (end_row - start_row)
        col = col - (end_col - start_col)
    end
    -- set the node to the new position
    vim.api.nvim_buf_set_text(0, row, col, row, col, ts_utils.get_text_from_node(node, 0))
end
function M.create_node_above(insert_node)
    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    cursor_row = cursor_row - 1  -- Convert to 0-indexed
    
    local parser, tree = get_parser_and_tree()
    local node = tree:root():descendant_for_range(cursor_row, cursor_col, cursor_row, cursor_col)
    
    -- Find the method the cursor is in
    local body_node = node
    while body_node do
        local method_type = body_node:type()
        if method_type == "block" then
            break
        end
        body_node = body_node:parent()
    end
    
    -- Get the child of the method body that contains the cursor
    local function find_cursor_child(n)
        for child in n:iter_children() do
            local start_row, start_col, end_row, end_col = child:range()
            if cursor_row >= start_row and cursor_row <= end_row and 
               cursor_col >= start_col and cursor_col <= end_col then
                return child
            end
        end
        return nil
    end
    
    local cursor_child = find_cursor_child(body_node)
    if not cursor_child then
        print("No child node found at cursor position")
        return
    end
    
    -- Get the start position of that node
    local start_row, start_col = cursor_child:range()
    
    -- Create the Grid object creation statement
    local grid_statement = insert_node
    
    -- Create proper indentation to match the current line
    local indentation = string.rep(" ", start_col)
    
    -- Insert the statement at the start of the cursor child node
    vim.api.nvim_buf_set_text(0, start_row, start_col, start_row, start_col, {grid_statement, indentation})
    
end

function create_django_object(identifier, class, properties)
    function table_to_key_value_string(tbl)
        local pairs_list = {}
        for key, value in pairs(tbl) do
            table.insert(pairs_list, key .. "=" .. tostring(value))
        end
        return table.concat(pairs_list, ", ")
    end 
    reduce = function(func, list, init)
        local acc = init
        for _, v in ipairs(list) do
            acc = func(acc, v)
        end
        return acc
    end
    formatted_properties = table_to_key_value_string(properties)
    return string.format('%s = %s.objects.create(%s)', identifier, class, formatted_properties)
end

function create_user()
    return create_django_object( 'self.user', 'CustomUser', {
        first_name="'user'",
        last_name="'name'",
        password="'password'"
    })
end

function create_grid()
    return create_django_object( 'grid', 'Grid', {name="'Grid_name'", gln="1234567890123", organization_number="123456789"})
end
function create_provider()
    return create_django_object( 'provider', 'Provider', {
    name =  "provider",
    description =  "description",
    url = "http://example.com",
    gln = "547290052749", --create valid gln function? provider?,
    organisation_number =  "dfjakslfdkasl",
    start = "datetime(2023, 1, 1)"
    })
end
function f()
    node = create_provider()
    M.create_node_above(node)
end
function c()
    node = create_user()
    M.create_node_above(node)
    
end

return M