local csharp = require("hilmare.csharp-refactor")
local python = require("hilmare.python-refactor")
local utils = require("hilmare.utils")

local M = {}

function M.setup()
    -- Leader keys
    vim.g.mapleader = 'ø'
    vim.g.maplocalleader = " "

    -- Search and replace current word
    vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

    -- Keep cursor centered when joining lines
    vim.keymap.set("n", "J", "mzJ`z")

    -- Navigate to method and center
    vim.keymap.set("n", "]m", "]mzt")

    -- Insert mode navigation
    vim.keymap.set("i", "<C-l>", "<Right>")

    -- Generate documentation
    vim.keymap.set("n", "<leader>dg", ":Neogen<CR>")

    -- Git diff with commit
    vim.keymap.set("n", "<leader>js", function()
        vim.ui.input({prompt = "Enter a commitish>"}, function(input)
            vim.cmd("Gvdiffsplit " .. input)
        end)
    end)

    -- C# specific keymaps
    vim.keymap.set("n", "øt", csharp.replace_var_with_type, { desc = "Replace var with explicit type" })

    vim.keymap.set("n", "øga", python.goto_first_argument, { desc = "Go to the first argument" })

    -- Base64 encoding/decoding
    vim.keymap.set("v", "øe", utils.encode_selection, { desc = "Base64 encode selection" })
    vim.keymap.set("v", "ød", utils.decode_selection, { desc = "Base64 decode selection" })
end

return M