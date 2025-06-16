vim.g.mapleader = 'ø'
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "]m", "]mzt")

vim.keymap.set("i", "<C-l>","<Right>")

vim.keymap.set("n", "<leader>dg", ":Neogen<CR>")

vim.keymap.set("n", "<leader>js", function ()
    vim.ui.input({prompt = "Enter a commitish>"}, function (input)
        vim.cmd("Gvdiffsplit " .. input )-- .." -- " .. vim.fn.expand("%"))
    end)
end)
-- vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
--   expr = true,
--   replace_keycodes = false
-- })
-- vim.g.copilot_no_tab_map = false
