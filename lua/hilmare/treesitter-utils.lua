local M = {}

function M.get_text_from_node(node, bufnr)
    if not bufnr then
        bufnr = 0
    end
    local x, y, z, w = node:range()
    return vim.api.nvim_buf_get_text(bufnr, x, y, z, w, {})
end

function M.replace_text_in_node(node, change_func, bufnr)
    if not bufnr then
        bufnr = 0
    end
    local x, y, z, w = node:range()
    local text = vim.api.nvim_buf_get_text(bufnr, x, y, z, w, {})
    local to_replace = change_func(text)
    vim.api.nvim_buf_set_text(bufnr, x, y, z, w, to_replace)
end

function M.iter_captures(query_string)
    local parser = vim.treesitter.get_parser(0, "c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", query_string)
    return query:iter_captures(tree:root(), 0)
end

function M.iter_matches(query_string)
    local parser = vim.treesitter.get_parser(0, "c_sharp")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("c_sharp", query_string)
    return query:iter_matches(tree:root(), 0)
end

function M.split(string, pattern)
    local results = {}
    local start = 1
    local split_start, split_end = string.find(string, pattern, start)

    while split_start do
        table.insert(results, string.sub(string, start, split_start - 1))
        start = split_end + 1
        split_start, split_end = string.find(string, pattern, start)
    end

    table.insert(results, string.sub(string, start))
    return results
end
function T()
    node = M.get_function_node_at_cursor(0)
    M.insert_parameter(node, "newParameter", 1)
end
function M.get_class_node_at_cursor(bufnr)
    if not bufnr then
        bufnr = 0
    end
    
    node = vim.treesitter.get_node()
    -- local cursor = vim.api.nvim_win_get_cursor(0)
    -- local row = cursor[1] - 1
    -- local col = cursor[2]
    
    -- local parser = vim.treesitter.get_parser(bufnr)
    -- local tree = parser:parse()[1]
    -- local root = tree:root()
    
    -- local node = root:named_descendant_for_range(row, col, row, col)
    vim.print()
    
    while node do
        vim.print(node)
        if node:type() == "class_declaration" then
            return node
        end
        node = node:parent()
    end
    
    return nil
end

function M.get_function_node_at_cursor(bufnr)
    if not bufnr then
        bufnr = 0
    end
    
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1
    local col = cursor[2]
    
    local parser = vim.treesitter.get_parser(bufnr)
    local tree = parser:parse()[1]
    local root = tree:root()
    
    local node = root:named_descendant_for_range(row, col, row, col)
    
    while node do
        local node_type = node:type()
        if node_type == "function_definition" or 
           node_type == "method_declaration" or 
           node_type == "function_declaration" or
           node_type == "constructor_declaration" or
           node_type == "arrow_function" or
           node_type == "function_expression" then
            return node
        end
        node = node:parent()
    end
    
    return nil
end

function M.insert_parameter(method_node, parameter_text, position, bufnr)
    if not bufnr then
        bufnr = 0
    end
    
    local parameter_list = nil
    for child in method_node:iter_children() do
        print(child:type())
        if child:type() == "parameter_list" or child:type() == "parameters" then
            parameter_list = child
            break
        end
    end
    
    if not parameter_list then
        return false
    end
    
    local parameters = {}
    for child in parameter_list:iter_children() do
        if child:type() ~= "(" and child:type() ~= ")" and child:type() ~= "," then
            table.insert(parameters, child)
        end
    end
    
    local insert_pos = position or (#parameters + 1)
    if insert_pos > #parameters + 1 then
        insert_pos = #parameters + 1
    elseif insert_pos < 1 then
        insert_pos = 1
    end
    
    local start_row, start_col, end_row, end_col = parameter_list:range()
    
    if #parameters == 0 then
        vim.api.nvim_buf_set_text(bufnr, start_row, start_col + 1, start_row, start_col + 1, {parameter_text})
        print("Inserted parameter at the start of the parameter list.")
    else
        print("Inserted parameter at ")
        print(insert_pos)
        if insert_pos == 1 then
            local first_param = parameters[1]
            local param_start_row, param_start_col = first_param:range()
            vim.api.nvim_buf_set_text(bufnr, param_start_row, param_start_col, param_start_row, param_start_col, {parameter_text .. ", "})
        elseif insert_pos > #parameters then
            local last_param = parameters[#parameters]
            local _, _, param_end_row, param_end_col = last_param:range()
            vim.api.nvim_buf_set_text(bufnr, param_end_row, param_end_col, param_end_row, param_end_col, {", " .. parameter_text})
        else
            local target_param = parameters[insert_pos]
            local param_start_row, param_start_col = target_param:range()
            vim.api.nvim_buf_set_text(bufnr, param_start_row, param_start_col, param_start_row, param_start_col, {parameter_text .. ", "})
        end
    end
    
    return true
end

function M.find_constructor_in_class(class_node)
    for child in class_node:iter_children() do
        if child:type() == "declaration_list" or child:type() == "class_body" then
            for member in child:iter_children() do
                if member:type() == "constructor_declaration" then
                    return member
                end
            end
        end
    end
    return nil
end

function M.find_all_constructors_in_class(class_node)
    local constructors = {}
    for child in class_node:iter_children() do
        if child:type() == "declaration_list" or child:type() == "class_body" then
            for member in child:iter_children() do
                if member:type() == "constructor_declaration" then
                    table.insert(constructors, member)
                end
            end
        end
    end
    return constructors
end

-- class
--     name
--     modifier
--     body
--     all instance variables
--     all methods
    
-- method
--     modifier
--     return_value
--     name
--     parameters
--     body
-- variable_declaration
--     type name 

return M