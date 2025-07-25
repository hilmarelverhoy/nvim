require("hilmare")
function explode(div,str)
    if (div=='') then return false end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
    end
    table.insert(arr,string.sub(str,pos))
    return arr
end
-- vim.api.nvim_buf_set_lines(0,16,16,false,T);
            vim.diagnostic.config {
                virtual_lines = false,
                virtual_text = false,
                underline = false,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "if_many",
                    header = "Diagnostics",
                },
            }
