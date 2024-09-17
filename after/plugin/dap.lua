local dap = require("dap")
dap.adapters.coreclr = {
  type = 'executable',
  command = [[C:\Users\ELVHIL\Downloads\netcoredbg-win64 (1)\netcoredbg]],
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
vim.keymap.set("n","<F5>", "<Cmd>lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>")
vim.keymap.set("n"," <F11>"," <Cmd>lua require'dap'.step_into()<CR>")
vim.keymap.set("n"," <F12>"," <Cmd>lua require'dap'.step_out()<CR>")
vim.keymap.set("n"," <Leader>","<localleader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n"," <Leader>","<leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n"," <Leader>","<leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n"," <Leader>","<localleader>dr <Cmd>lua require'dap'.repl.open()<CR>")
vim.keymap.set("n"," <Leader>","<localleader>dl <Cmd>lua require'dap'.run_last()<CR>")
