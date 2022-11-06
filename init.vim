set nocompatible            " disable compatibility to old-time vi

set autoindent              " indent a new line the same amount as the line just typed
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing

syntax on                   " syntax highlighting
filetype plugin indent on   " allow auto-indenting depending on file type
set ttyfast                 " Speed up scrolling in Vim

set clipboard=unnamedplus   " using system clipboard

set hlsearch                " highlight search 
set incsearch               " incremental search
set ignorecase              " case insensitive 

set number                  " add line numbers
set showmatch               " parenthesis/bracket match highlight
set mouse=a                 " enable mouse click
set mouse=v                 " middle-click paste with 

set wildmode=full           " get bash-like tab completion
set path+=**                " recursive file search
set wildmenu                " menu for file search
set wildoptions=pum
set wildcharm=<Tab>
" :find filename<tab>         glob works as well. tab/shift-tab scrolls
" :ls                         list buffers
" :b filename                 no need to type full filename, if it's unique it'll jump

" netrw
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3

" === functionality ===
" autocomplete
" ctrl+n does the symbol search.
"   once the menu pops up, use ctrl+n/p for browsing.
"   ctrl+x ctrl+n limits the search to current file.
"   ctrl+x ctrl+f looks for filenames.

" === mappings ===
" clear search highlighting
nnoremap <C-h> :noh <enter>

" popup menu for open buffers
nnoremap <C-o> :buffer<Space><Tab>

" find file
nnoremap <C-S-f> :find<Space>

" search word under cursor in repo using ripgrep
" uses register @a
nnoremap <C-f> "ayiw :execute 'terminal rg ' @a<enter>i

" copy word under cursor to clipboard 
nnoremap <C-c> yiw 

" wishlist
" search and replace
