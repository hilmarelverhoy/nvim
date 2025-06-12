local conf = require("telescope.config").values
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
require'telescope'.load_extension('project')
local builtin = require('telescope.builtin')
local path;
local sitepath;
if vim.loop.os_uname().sysname == "Darwin" or vim.loop.os_uname().sysname == "Linux" then
    path = "~/.config/nvim"
else
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim"
end

if vim.loop.os_uname().sysname == "Darwin" or vim.loop.os_uname().sysname == "Linux" then
    sitepath = "~/.local/share/nvim/"
else
    sitepath = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data"
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
vim.keymap.set('n', '<leader>C', function ()
    local config = {
        -- hidden = true,
        cwd = sitepath
    }
    builtin.find_files(config)
end, {})

vim.keymap.set('n','æe',
    function ()
        local opts = {}
        local find_command = { "rg","--files", "--color", "never", ".", "exe"}
        pickers
            .new(opts, {
                prompt_title = "Find Files",
                finder = finders.new_oneshot_job(find_command, opts),
                previewer = conf.file_previewer(opts),
                sorter = conf.file_sorter(opts),
            })
            :find()
    end
,{})

vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gh', require'telescope'.extensions.git_file_history.git_file_history, {})

vim.keymap.set('n', '<leader>lw', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>ls', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set('n', '<leader>ld', builtin.lsp_document_symbols, {})
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
                autotavla = "~/Autotavla/",
                gse = "~/GeoguessrScoringEngine//"
            },
            hidden_files = true,
            theme = "dropdown",
        },
    },
}

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"
-- require("telescope").load_extension("git_file_history")
-- This is your opts table
require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            },

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeaction"
            --specific_opts = {
            --    ["codeaction"] = {
            --        make_indexed = function(items)
            --            local indexed_items = {}
            --            local width = 10
            --            for i, item in ipairs(items) do
            --                print(item)
            --                table.insert(indexed_items, {
            --                    idx = i,
            --                    text = item
            --                })
            --            end
            --            return indexed_items, width
            --        end,
            --        -- make_displayer = function(widths) -> displayer
            --        -- make_display = function(displayer) -> function(e)

            --        make_ordinal = function(e)
            --            -- vim.print(e)
            --            return e.idx
            --        end,
            --    },
            --    -- for example to disable the custom builtin "codeactions" display
            --    --do the following
            --}
        }
    }
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
