-- vim.keymap.set("n", "<leader>a", nil )
require("claudecode").setup()
vim.keymap.set("n",   "<leader>ac", "<cmd>ClaudeCode<cr>" )
vim.keymap.set("n",    "<leader>af", "<cmd>ClaudeCodeFocus<cr>" )
vim.keymap.set("n",    "<leader>ar", "<cmd>ClaudeCode --resume<cr>" )
vim.keymap.set("n",    "<leader>aC", "<cmd>ClaudeCode --continue<cr>" )
vim.keymap.set("n",    "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>" )
vim.keymap.set("v",    "<leader>as", "<cmd>ClaudeCodeSend<cr>" )
    -- Diff management
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>" )
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>" )

