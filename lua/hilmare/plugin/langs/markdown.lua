local ls = require("luasnip")
local text = ls.text_node
local insert = ls.insert_node
local f = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node

local rec_ls
rec_ls = function()
    return ls.snippet_node(
        nil,
        choice(1, {
            text(""),
            ls.snippet_node(nil,
            {
                text({"","-"}),
                insert(1),
                dynamic(2, rec_ls, {})
            })
        })
    )
end

ls.add_snippets("markdown",{
    ls.snippet("i", {
        text("*"),
        insert(0),
        text("*")
    }),
    ls.snippet("b", {
        text("**"),
        insert(1),
        text("**")
    }),
    ls.snippet("h1", {
        text("# "),
        insert(0),
        text({"",""})
    }),
    ls.snippet("h2", {
        text("## "),
        insert(0),
        text({"",""}),
    }),
    ls.snippet("h3", {
        text("### "),
        insert(1),
        text("","")
    }),
    ls.snippet("li", {
        text(""),
        dynamic(1, rec_ls,{}),
    })
})


