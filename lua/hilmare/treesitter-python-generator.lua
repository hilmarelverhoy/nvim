local function generate_node(node, source)
    if not node then
        return ""
    end
    node_type = node:type()
    if node_type == "identifier" then
        return "identifier"
    elseif node_type == "import_statement" then
        local child_list = source[0]
        for child in {table.unpack(source, startIndex, #source)} do
            child_list = child_list .. ", " .. child
        end
        return source .. child_list
    end
end
local function generate_python_code(node, source)
    if not node then
        return ""
    end
    
    local node_type = node:type()
    local start_row, start_col, end_row, end_col = node:range()
    
    if node:child_count() == 0 then
        return generate_node(node, {})
    end
    
    local children_code = {}
    for child in node:iter_children() do
        local child_code = generate_python_code(child, source)
        if child_code and child_code ~= "" then
            table.insert(children_code, child_code)
        end
    end
    generate_node(node, children_code)
    
    if #children_code == 0 then
        return node_text
    end
    
    return table.concat(children_code, "")
end


return {
    generate_python_code = generate_python_code,
    run = function()
        local source = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local opts = {
            bufnr = 0,
            pos = nil,
            source = source
        }
        local node = vim.treesitter.get_node(opts)
        return generate_python_code(node, source)
    end
}
