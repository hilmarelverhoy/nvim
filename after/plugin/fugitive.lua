local hilmare_Fugitive = vim.api.nvim_create_augroup("hilmare_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = hilmare_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        vim.keymap.set("n", "<leader>gs", vim.cmd('Git'))
        --local bufnr = vim.api.nvim_get_current_buf()
        --local opts = {buffer = bufnr, remap = false}
        --vim.keymap.set("n", "<leader>p", function()
        --    vim.cmd.Git('push')
        --end, opts)

        ---- rebase always
        --vim.keymap.set("n", "<leader>P", function()
        --    vim.cmd.Git({'pull',  '--rebase'})
        --end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
    end,
})

vim.keymap.set("n", "ømr",":diffget *REMOTE*<CR>",{})
vim.keymap.set("n", "ømb",":diffget *BASE*<CR>",{})
vim.keymap.set("n", "øml",":diffget *LOCAL*<CR>",{})
vim.keymap.set("n", "ømn","/<<<<<<CR>zt",{})
