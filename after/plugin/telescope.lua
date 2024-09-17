local conf = require("telescope.config").values
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
require'telescope'.load_extension('project')
require'telescope'.load_extension('git_file_history')
local builtin = require('telescope.builtin')
local path;
if vim.loop.os_uname().sysname == "Darwin" then
    path = "~/.config/nvim"
else
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim"
end

vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>c', function ()
    local config = {
        -- hidden = true,
        cwd = path
    }
    builtin.find_files(config)
end, {})

vim.keymap.set('n','<leader>q',
    function ()
        local opts = {}
        local find_command = { "rg","--files", "--color", "never", ".","*.exe"}
        pickers
            .new(opts, {
                prompt_title = "Find Files",
                finder = finders.new_oneshot_job(find_command, opts),
                previewer = conf.file_previewer(opts),
                sorter = conf.file_sorter(opts),
            })
            :find()
        print("hei")
    end
,{})
vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gh', require'telescope'.extensions.git_file_history.git_file_history, {})

vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>wds', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>q', builtin.quickfix, {})
vim.keymap.set('n', '<leader>tp', require 'telescope'.extensions.project.project, {})
-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
    "n",
    "<leader>nw",
    ":Telescope file_browser<CR>",
    { noremap = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>nc",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { noremap = true }
)
-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
local project_actions = require("telescope._extensions.project.actions")
require("telescope").setup {
    extensions = {
        file_browser = {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                    -- your custom insert mode mappings
                },
                ["n"] = {
                    -- your custom normal mode mappings
                },
            },
        },
        project = {
            base_dirs = {
                "C:\\Users\\ELVHIL\\AppData\\Local\\nvim",
                "C:\\Users\\ELVHIL\\fido",
                "C:\\Users\\ELVHIL\\fidov2",
            },
            hidden_files = true,
            theme = "dropdown",
        },
    },
}

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"
require("telescope").load_extension("git_file_history")
