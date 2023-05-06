local o = vim.opt

o.autoindent = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

o.hlsearch = true
o.incsearch = true

o.ignorecase = true

o.clipboard = "unnamedplus"

o.number = true
o.relativenumber = true

o.showmatch = true
o.mouse = "a"

-- mostly obsolete due to fzf.vim
o.path = "**"
o.wildoptions = "pum,fuzzy"
o.wildmode = "longest,list"
o.wildmenu = true

-- do not insert completion suggestions in
-- insert mode eagerly, wait for input. 
o.completeopt = "menu,noinsert"

vim.cmd([[colorscheme codedark]])
vim.cmd([[filetype indent plugin on]])
o.background = "dark"
