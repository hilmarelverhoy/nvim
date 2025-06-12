if vim.loop.os_uname().sysname == "Darwin" then
else
    require 'nvim-treesitter.install'.compilers = { "gcc" }
end
local ensure
if vim.loop.os_uname().sysname == "Darwin" then
    ensure = { "c", "lua", "vim", "c_sharp", "query", "http", "json", "js" }
else
    ensure = { "c", "dart", "lua", "vim", "vimdoc", "c_sharp", "query", "http", "json", "xml", "javascript", "python" }
end
-- local path = [[C:\Users\Elvhil\Maskinoppsett\]]
-- vim.opt.runtimepath:append(path)
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = ensure,

    modules = {},
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    indent = {
        enable = true,
    },

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<leader>v", -- set to `false` to disable one of the mappings
            node_incremental = "v",
            scope_incremental = "C-V",
            node_decremental = "V",
        },
    },
}
