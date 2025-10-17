syntax on
filetype plugin indent on
colorscheme habamax

set mouse=a
set nocompatible
set clipboard+=unnamedplus
set hidden

set incsearch

set number
set relativenumber


map <A-s> :split<CR>
map <A-v> :vsplit<CR>

map <A-h> <C-w>h
map <A-j> <C-w>j
map <A-k> <C-w>k
map <A-l> <C-w>l

map <A-t>   :tabnew<CR>
map <A-S-t> <C-w>T
map <C-A-l> gt
map <C-A-h> gT

map <A-w> :w<CR>
map <A-q> :q<CR>

set wildcharm=<C-z>
map <A-o>   :rightbelow vsplit **/<C-z>
map <C-A-o> :tabnew **/<C-z>

map <A-b>   :buffer <C-z>
