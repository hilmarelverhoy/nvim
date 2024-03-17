-- local lspconfig = require'lspconfig'
-- lspconfig.csharp_ls.setup( {
--     root_dir = function(startpath)
--         return lspconfig.util.root_pattern("*.sln")(startpath)
--             or lspconfig.util.root_pattern("*.csproj")(startpath)
--             or lspconfig.util.root_pattern("*.fsproj")(startpath)
--             or lspconfig.util.root_pattern(".git")(startpath)
--     end
-- })
-- placeholder 2,...
local function copy(args)
	return args[1]
end
local function makename(args)
     local a = args[1][1]:sub(1,2)
     local b = args[1][1]:sub(3)
     if a:sub(1,1) == "I" then
         a = a:sub(2,2)
     else
         b = args[1][1]:sub(3)

     end
     a = a:lower()
     return a..b
 end
 local function get_filename()
     return vim.fn.expand("%:t:r")
 end

 local function get_class_name()
     local opts = {}
     opts["bufnr"] = 0
     opts["pos"] = nil
     local node = vim.treesitter.get_node(opts)
     if not node then
         return nil
     end
     local next = node:parent()
     while next do
         if next:type() == "class_declaration" then
             local t = next:iter_children()
             for index, _ in t do
                 if index:type() == "identifier" then
                     local start_col, start_row, end_col, end_row = index:range()
                     local text = vim.api.nvim_buf_get_text(0, start_col,start_row,end_col, end_row, {});
                     return text[1]
                 end
             end
         end
         next = next:parent()
     end

     return vim.fn.expand("%:t:r")
 end

 local ls = require("luasnip")
 local text = ls.text_node
 local insert = ls.insert_node
 local f = ls.function_node
 ls.add_snippets("cs",{
     ls.snippet("fn", {
         -- Simple static text.
         -- function, first parameter is the function, second the Placeholders
         -- whose text it gets as input.
         ls.choice_node(4,{text("public"), text("private")}),
         text(" "),
         -- Placeholder/Insert.
         insert(3, "Type"),
         text(" "),
         insert(1),
         text("("),
         -- Placeholder with initial text.
         insert(2, "int foo"),
         text({ ")",""}),
         text({ "{"  ,"\t"}),
         -- Last Placeholder, exit Point of the snippet.
         insert(0),
         text({ "", "}" }),
     }),
     ls.snippet("afn", {
         -- Simple static text.
         -- function, first parameter is the function, second the Placeholders
         -- whose text it gets as input.
         ls.choice_node(4,{text("public"), text("private")}),
         text(" async "),
         -- Placeholder/Insert.
         ls.choice_node(3, {
             ls.snippet_node(nil,{
                 text("Task<"),
                 insert(1, "Type"),
                 text(">")
             }),
             text("Task"),
             text("void")
         }),
         text(" "),
         insert(1),
         text("("),
         -- Placeholder with initial text.
         insert(2, "int foo"),
         text({ ")",""}),
         text({ "{"  ,"\t"}),
         -- Last Placeholder, exit Point of the snippet.
         insert(0),
         text({ "", "}" }),
     }),
     ls.snippet("cls", {
         ls.choice_node(2,{text("public"),text("protected"), text("private"), text("internal")}), text(" class "), f(get_filename),
         text({ "" ,""}),
         -- todo: inheritance
         text({ "{" ,"\t" }),
         insert(3, {"Type variable", ""}),
         text({ ""  ,"\t"}),
         ls.choice_node(1,{text("public"),text("protected"), text("private"), text("internal")}), text({" ",}), f(get_filename), text({ "()", "\t"}),
         text({ "{"  ,"\t\t"}),
         insert(0),
         text({ "", "\t}" }),
         text({ "", "}" }),
     }),
     ls.snippet("ctor",{
         text("public "),
         f(get_class_name),
         text("()", ""),
         text({ "{"  ,"\t"}),
         insert(0),
         text({ ""  ,"}"}),
     }),
     ls.snippet("inst", {
         text("private readonly "),
         insert(1, "Type"),
         text(" _"),
         f(makename,1),
         insert(2),
         text({";", ""}),
     })

 },{key = "csharp"})

 vim.diagnostic.config({
     virtual_text = true,
 })
 vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
     pattern = {"*.cs","*.csproj", "*.targets"},
     command = "compiler dotnet",
 })
 vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
     pattern = {"*.cs","*.csproj", "*.targets"},
     callback = function ()
         vim.keymap.set("n", "<localleader>r", function ()
             require("neotest").run.run()
         end , {})
         vim.keymap.set("n", "<localleader>r", function ()
             require("neotest").run.run()
         end , {})
         vim.keymap.set("n", "<localleader>R", function ()
             require("neotest").run.run(vim.fn.expand("%"))
         end, {})
         vim.keymap.set("n",  "<localleader>m", ":wa<Enter>:Make<Enter>")
         vim.keymap.set("n",  "<localleader>m", ":wa<Enter>:Make<Enter>")
         vim.keymap.set("n", "<localleader>w", [[:Start! iisexpress.exe /config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config /siteid:2<CR>]])



     end
 })

 vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
     pattern = {"http"},
     callback = function ()
         vim.keymap.set("n",  "<localleader>r", "<Plug>RestNvim")
         vim.keymap.set("n",  "<localleader>p",  "<Plug>RestNvimPreview")
         vim.keymap.set("n", "<localleader>w", [[:Start! iisexpress.exe /config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config /siteid:2<CR>]])



     end
 })
 local Job = require'plenary.job'
 local async = require'plenary.async'
 local job = async.void(
 function ()
     local job = Job:new({
         command = 'iisexpress.exe',
         args = { [[/config:C:\Users\ELVHIL\Documents\IISExpress\config\applicationhost.config ]], [[/siteid:2]] },
         -- cwd = [[C:\Users\ELVHIL\Documents\IISExpress\]],
         env = { ['a'] = 'b' },
         on_exit = function(j, return_val)
             print(return_val)
             print(vim.inspect(j:result()))
         end,
     })
     job:start()
 end
 )
 vim.keymap.set("n", "<leader>w", function ()
     job ""
 end, {})


