require'nvim-treesitter.configs'.setup {
    textobjects = {
        lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
                ["<leader>ob"] = "@block.inner",
                ["<leader>ov"] = "@call.inner",
                ["<leader>oc"] = "@class.inner",
                ["<leader>oe"] = "@comment.outer", --inner not supported in cs
                ["<leader>ou"] = "@conditional.inner",
                ["<leader>of"] = "@function.inner",
                ["<leader>ol"] = "@loop.inner",
                ["<leader>o,"] = "@parameter.inner",
                ["<leader>oob"] = "@block.outer",
                ["<leader>oov"] = "@call.outer",
                ["<leader>ooc"] = "@class.outer",
                ["<leader>ooe"] = "@comment.outer", --inner not supported in cs
                ["<leader>oou"] = "@conditional.outer",
                ["<leader>oof"] = "@function.outer",
                ["<leader>ool"] = "@loop.outer",
                ["<leader>oo,"] = "@parameter.outer",
                ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
        },
        -- block io b
        -- call io v
        -- class io c
        -- comment o e
        -- condition io i
        -- function io f
        -- loop io l
        -- param io ,
        --
        --[ next start
        --] next end
        -- inner
        --add o outer
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["[b"] = "@block.inner",
                ["[v"] = "@call.inner",
                ["[c"] = "@class.inner",
                ["[e"] = "@comment.outer", --inner not supported in cs
                ["[i"] = "@identifier.outer", --inner not supported in cs
                ["[u"] = "@conditional.inner",
                ["[f"] = "@function.inner",
                ["[l"] = "@loop.inner",
                ["[,"] = "@parameter.inner",
                ["[ob"] = "@block.outer",
                ["[ov"] = "@call.outer",
                ["[oc"] = "@class.outer",
                ["[oe"] = "@comment.outer", --inner not supported in cs
                ["[ou"] = "@conditional.outer",
                ["[of"] = "@function.outer",
                ["[ol"] = "@loop.outer",
                ["[o,"] = "@parameter.outer",
                ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
                ["]b"] = "@block.inner",
                ["]v"] = "@call.inner",
                ["]c"] = "@class.inner",
                ["]e"] = "@comment.outer", --inner not supported in cs
                ["]i"] = "@identifier.outer", --inner not supported in cs
                ["]u"] = "@conditional.inner",
                ["]f"] = "@function.inner",
                ["]l"] = "@loop.inner",
                ["],"] = "@parameter.inner",
                ["]ob"] = "@block.outer",
                ["]ov"] = "@call.outer",
                ["]oc"] = "@class.outer",
                ["]oe"] = "@comment.outer", --inner not supported in cs
                ["]ou"] = "@conditional.outer",
                ["]of"] = "@function.outer",
                ["]ol"] = "@loop.outer",
                ["]o,"] = "@parameter.outer",
                ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_previous_start = {
                ["[B"] = "@block.inner",
                ["[V"] = "@call.inner",
                ["[C"] = "@class.inner",
                ["[E"] = "@comment.outer", --inner not supported in cs
                ["[I"] = "@identifier.outer", --inner not supported in cs
                ["[U"] = "@conditional.inner",
                ["[F"] = "@function.inner",
                ["[L"] = "@loop.inner",
                ["[,"] = "@parameter.inner",
                ["[oB"] = "@block.outer",
                ["[oV"] = "@call.outer",
                ["[oC"] = "@class.outer",
                ["[oE"] = "@comment.outer", --inner not supported in cs
                ["[oU"] = "@conditional.outer",
                ["[oF"] = "@function.outer",
                ["[oL"] = "@loop.outer",
                ["[o,"] = "@parameter.outer",
                ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_previous_end = {
                ["]B"] = "@block.inner",
                ["]V"] = "@call.inner",
                ["]C"] = "@class.inner",
                ["]E"] = "@comment.outer", --inner not supported in cs
                ["]I"] = "@identifier.outer", --inner not supported in cs
                ["]U"] = "@conditional.inner",
                ["]F"] = "@function.inner",
                ["]L"] = "@loop.inner",
                ["];"] = "@parameter.inner",
                ["]oB"] = "@block.outer",
                ["]oV"] = "@call.outer",
                ["]oC"] = "@class.outer",
                ["]oE"] = "@comment.outer", --inner not supported in cs
                ["]oU"] = "@conditional.outer",
                ["]oF"] = "@function.outer",
                ["]oL"] = "@loop.outer",
                ["]o;"] = "@parameter.outer",
                ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
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
                ["ib"] = "@block.inner",
                ["iv"] = "@call.inner",
                ["ic"] = "@class.inner",
                ["ie"] = "@comment.outer", --inner not supported in cs
                ["ii"] = "@identifier.outer", --inner not supported in cs
                ["iu"] = "@conditional.inner",
                ["if"] = "@function.inner",
                ["il"] = "@loop.inner",
                ["i,"] = "@parameter.inner",
                ["ab"] = "@block.outer",
                ["av"] = "@call.outer",
                ["ac"] = "@class.outer",
                ["ae"] = "@comment.outer", --inner not supported in cs
                ["ai"] = "@identifier.outer", --inner not supported in cs
                ["au"] = "@conditional.outer",
                ["af"] = "@function.outer",
                ["al"] = "@loop.outer",
                ["a,"] = "@parameter.outer",
                ["az"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                --
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
