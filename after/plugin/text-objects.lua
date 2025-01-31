require'nvim-treesitter.configs'.setup {
    textobjects = {
        lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
                ["<leader>of"] = "@function.outer",
                ["<leader>oF"] = "@class.outer",
            },
        },
        -- block io b
        -- call io v
        -- class io c
        -- comment o x
        -- condition io i
        -- function io f
        -- loop io l
        -- param io ,
        --
        --[ start
        --] end
        --lowercase inner
        --uppercase outer
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["[m"] = "@function.outer",
                ["[["] = { query = "@class.outer", desc = "Next class start" },
                ["[o"] = { query = { "@loop.inner", "@loop.outer" } },
                ["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
            goto_previous_start = {
                ["]n"] = "@name",
                ["]m"] = "@function.outer",
                ["]["] = "@class.outer",
                ["]s"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },
            },
            goto_previous_end = {
                ["]M"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
        },
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                -- nvim_buf_set_keymap) which plugins like which-key display
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                -- You can also use captures from other query groups like `locals.scm`
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                ["a,"] = { query = "@parameter.outer", desc = "Parameter"},
                ["i,"] = { query = "@parameter.inner", desc = "Parameter"},
                ["aC"] = "@call.outer",
                ["iC"] = "@call.inner",
                ["a/"] = "@comment.outer",
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = false,
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>l"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>h"] =  "@parameter.inner"
            },
        },

    },
}
local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
