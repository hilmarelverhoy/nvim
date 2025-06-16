vim.opt.tabstop=4
vim.opt.softtabstop=4 -- How many spaces a tab feels like
vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.smarttab = true
vim.opt.showtabline=2
vim.opt.hidden=true
vim.opt.magic=true
vim.opt.ignorecase=true
vim.opt.smartcase=true
-- vim.opt.smartindent=true
vim.opt.list=true
vim.opt.listchars="tab:-> ,trail:·,nbsp:·"

vim.opt.autoindent = true
vim.opt.clipboard="unnamedplus"
--Wildcards
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.wildignore:append(
    [[
        .DS_Store,
        *.jpg,*.jpeg,*.gif,*.png,*.gif,
        *.psd,*.o,*.obj,*.min.js,*.class
    ]])
vim.opt.incsearch = true
--set background=dark
vim.opt.fileformats="dos,unix"

--let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
--set spelllang=en,nb
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') ..  "/.vim/undodir"
vim.opt.backupdir = vim.fn.stdpath('data') .. "/.vim/backup"
vim.opt.directory = vim.fn.stdpath('data') ..  "/.vim/swp"

--Window stuff
vim.opt.splitright=true
vim.opt.splitbelow=true
vim.opt.winminheight=0
vim.opt.textwidth=88

vim.opt.number = true
vim.opt.rnu = true

vim.opt.fixeol = false
vim.opt.wrap = false
