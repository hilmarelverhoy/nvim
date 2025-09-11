local ts_utils = require("hilmare.treesitter-utils")

local function get_type_from_hover_result(results)
    local type_definition = ""
    
    for client_id, resp in pairs(results) do
        local err, result = resp.err, resp.result
        if err then
            vim.lsp.log.error(err.code, err.message)
        elseif result and result.contents and result.contents.value then
            local v = result.contents.value
            if v and #v > 6 then
                local b = string.sub(v, 4, #v - 3):reverse()
                local x = string.find(b, " ")
                if x then
                    type_definition = b:sub(x + 1):reverse()
                    break
                end
            end
        end
    end
    
    if type_definition == "" or type_definition == nil then
        type_definition = vim.fn.input("Enter type:")
    end
    
    return type_definition
end

local function configure_await_false()
    local parser = vim.treesitter.get_parser(0, "c_sharp")
    local tree = parser:parse()[1]
    local query_string = [[
    (await_expression
        (invocation_expression
            [(member_access_expression
                (identifier)@identifier
                )
                (identifier)@identifier
            ]
            )
        )@await]]
        
    local query = vim.treesitter.query.parse("c_sharp", query_string)
    for id, capture, metadata in query:iter_matches(tree:root(), 0) do
        if (capture[1] ~= "ConfigureAwait") then
            local _, _, row, col = capture[2]:range()
            vim.api.nvim_buf_set_text(0, row, col, row, col, {".ConfigureAwait(false)"})
        end
    end
end

local function add_null_check()
    local query_string = [[
    (binary_expression 
        left: (member_access_expression
            expression:
            (identifier)@i 
            name: (identifier)@a(#eq? @a "GyldigTil")
            )
        right: (identifier)
        )@res
    ]]
    for _, matches, _ in ts_utils.iter_matches(query_string) do
        local variable = matches[1]
        local binary = matches[3]
        local replacement_fn = function(_)
            local text = ts_utils.get_text_from_node(variable, 0)
            local text2 = ts_utils.get_text_from_node(binary, 0)
            return { "("..text[1]..".GyldigTil == null || ".. text2[1] .. ")"}
        end
        ts_utils.replace_text_in_node(binary, replacement_fn, 0)
    end
end

local function replace_var_with_type()
    vim.api.nvim_feedkeys("n", "mZ", false)
    local query_string = [[
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
    ]]
    local matches = ts_utils.iter_matches(query_string)
    for i, match, _ in matches do
        local t = vim.lsp.util.make_position_params()
        local x, y, _, _ = match[2]:range()
        t["position"]["character"] = y
        t["position"]["line"] = x
        
        vim.lsp.buf_request_all(0, vim.lsp.protocol.Methods.textDocument_hover, t, function(results, ctx)
            local type_identifier = get_type_from_hover_result(results)
            ts_utils.replace_text_in_node(match[1], function (_)
                return { type_identifier }
            end)
        end)
    end
    vim.api.nvim_feedkeys("n", "`Z", false)
end

local M = {}
M.configure_await_false = configure_await_false
M.add_null_check = add_null_check
M.replace_var_with_type = replace_var_with_type
M.get_type_from_hover_result = get_type_from_hover_result

return M