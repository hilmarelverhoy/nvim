local M = {}

function M.encode_selection()
    local _, ls, cs = unpack(vim.fn.getpos('v'))
    local _, le, ce = unpack(vim.fn.getpos('.'))
    local text = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
    local concatted = table.concat(text, "\n")
    local encoded = vim.base64.encode(concatted)
    vim.api.nvim_buf_set_text(0, ls - 1, cs - 1, le - 1, ce, {encoded})
    vim.api.nvim_feedkeys("v", "v", false)
end

function M.decode_selection()
    local _, ls, cs = unpack(vim.fn.getpos('v'))
    local _, le, ce = unpack(vim.fn.getpos('.'))
    local text = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
    local concatted = table.concat(text, "")
    local stripped = concatted:match("^%s*(.-)%s*$")
    local decoded = vim.base64.decode(stripped)
    local lines = {}
    for line in decoded:gmatch("[^\n]*") do
        table.insert(lines, line)
    end
    vim.api.nvim_buf_set_text(0, ls - 1, cs - 1, le - 1, ce, lines)
end

-- Custom vim.ui.select implementation
function M.setup_ui_select()
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
        local on_confirm = function(input)
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
end

return M