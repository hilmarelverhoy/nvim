-- DAP Configuration for Python/Django debugging
local dap = require('dap')
local dapui = require("dapui")

-- Setup DAP UI
dapui.setup()

-- Setup Python DAP
require('dap-python').setup('python')

-- Django test configuration
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Django Tests",
    program = "${workspaceFolder}/manage.py",
    args = { "test", "${input:test_path}" },
    django = true,
    cwd = "${workspaceFolder}",
    env = {
      DJANGO_SETTINGS_MODULE = "slipper.settings",
    },
    console = "integratedTerminal",
    justMyCode = false,
  },
  {
    type = 'python',
    request = 'launch',
    name = "Django Tests (Docker)",
    program = "docker-compose",
    args = { "run", "--rm", "web", "python", "manage.py", "test", "${input:test_path}" },
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    justMyCode = false,
  },
  {
    type = 'python',
    request = 'launch',
    name = "Django Runserver",
    program = "${workspaceFolder}/manage.py",
    args = { "runserver" },
    django = true,
    cwd = "${workspaceFolder}",
    env = {
      DJANGO_SETTINGS_MODULE = "slipper.settings",
    },
    console = "integratedTerminal",
    justMyCode = false,
  },
  {
    type = 'python',
    request = 'launch',
    name = "Python: Current File",
    program = "${file}",
    console = "integratedTerminal",
    justMyCode = false,
  },
}

-- Helper function to get test under cursor
local function get_test_under_cursor()
  local current_file = vim.fn.expand('%:p')
  local workspace = vim.fn.getcwd()
  local relative_path = vim.fn.substitute(current_file, workspace .. '/', '', '')
  local test_path = vim.fn.substitute(relative_path, '/', '.', 'g')
  test_path = vim.fn.substitute(test_path, '.py$', '', '')
  
  -- Get current line and search backwards for test method or class
  local current_line = vim.fn.line('.')
  local test_method = nil
  local test_class = nil
  
  -- Search backwards for test method (def test_*)
  for i = current_line, 1, -1 do
    local line = vim.fn.getline(i)
    if string.match(line, "^%s*def%s+(test_[%w_]+)") then
      test_method = string.match(line, "def%s+(test_[%w_]+)")
      break
    end
  end
  
  -- Search backwards for test class (class Test*)
  for i = current_line, 1, -1 do
    local line = vim.fn.getline(i)
    if string.match(line, "^class%s+([%w_]*[Tt]est[%w_]*)") then
      test_class = string.match(line, "class%s+([%w_]*[Tt]est[%w_]*)")
      break
    end
  end
  
  if test_method and test_class then
    return test_path .. "." .. test_class .. "." .. test_method
  elseif test_class then
    return test_path .. "." .. test_class
  else
    return test_path
  end
end

-- Input configuration for test paths
dap.configurations.python = vim.list_extend(dap.configurations.python, {
  {
    type = 'python',
    request = 'launch',
    name = "Django Test Current File",
    program = "${workspaceFolder}/manage.py",
    args = function()
      local current_file = vim.fn.expand('%:p')
      local workspace = vim.fn.getcwd()
      local relative_path = vim.fn.substitute(current_file, workspace .. '/', '', '')
      local test_path = vim.fn.substitute(relative_path, '/', '.', 'g')
      test_path = vim.fn.substitute(test_path, '.py$', '', '')
      return { "test", test_path }
    end,
    django = true,
    cwd = "${workspaceFolder}",
    env = {
      DJANGO_SETTINGS_MODULE = "slipper.settings",
    },
    console = "integratedTerminal",
    justMyCode = false,
  },
  {
    type = 'python',
    request = 'launch',
    name = "Django Test Under Cursor",
    program = "${workspaceFolder}/manage.py",
    args = function()
      return { "test", get_test_under_cursor() }
    end,
    django = true,
    cwd = "${workspaceFolder}",
    env = {
      DJANGO_SETTINGS_MODULE = "slipper.settings",
    },
    console = "integratedTerminal",
    justMyCode = false,
  },
  {
    type = 'python',
    request = 'launch',
    name = "Django Test Under Cursor (Docker)",
    program = "docker-compose",
    args = function()
      return { "run", "--rm", "web", "python", "manage.py", "test", get_test_under_cursor() }
    end,
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    justMyCode = false,
  },
})

-- Input variables
vim.ui.input = vim.ui.input or function(opts, on_confirm)
  local input = vim.fn.input(opts.prompt or "Input: ", opts.default or "")
  on_confirm(input)
end

-- Add input configuration
vim.g.dap_ui_config = {
  inputs = {
    test_path = {
      prompt = "Test path (e.g. accounts.tests or accounts.tests.test_models.TestUser): ",
      default = "",
    },
  },
}

-- Auto open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Key mappings
vim.keymap.set('n', '<F5>', dap.continue, { desc = "Debug: Start/Continue" })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = "Debug: Set Conditional Breakpoint" })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = "Debug: Open REPL" })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = "Debug: Run Last" })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Debug: Toggle UI" })