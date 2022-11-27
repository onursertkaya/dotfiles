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
set path=**                 " recursive file search, only within cwd
set wildmenu                " menu for file search
set wildoptions=pum         " popupmenu for wildmode
set wildcharm=<Tab>         " wildmode is triggered with tab

" netrw
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3

" === Commands ===
" :open filename<tab>
" :find filename<tab>         glob works as well. tab/shift-tab scrolls
" :ls                         list buffers
" :b filename                 no need to type full filename, if it's unique it'll jump

" === Default functionality ===
" word: default delimiters, WORD: whitespace delimiter
"   applies for b,e,w <> B,E,W
"
" normal mode
" x: remove char under cursor
" s: substitute character
" S: substitute line
" C: start substitution towards the end of line
" d*: delete *={b,e,w}

" going into insert mode
" I: beggining of line
" i: before cursor
" a: after cursor
" A: end of line
" O: previous line
" o: next line
"
" default mode line navigation
" line navigation:
"   hjkl: left,down,up,right
"   current word:
"     b: start
"     e: end
"   previous word:
"     bb: start
"     ge: end
"   next word:
"     w: start
"     we: end

" screen navigation:
"   zz: center screen around cursor
"   ctrl+y: up
"   ctrl+e: down

" autocomplete
" ctrl+n does the symbol search.
"   once the menu pops up, use ctrl+n/p for browsing.
"   ctrl+x ctrl+n limits the search to current file.
"   ctrl+x ctrl+f looks for filenames.

" split and navigation
" ctrl+w triggers the split control
"   s: horizontal new split
"   v: vertical new split
"   hjkl: navigation
"   ><: increase/decrease width
"   +-: increase/decrease height
" === mappings ===
" clear search highlighting
nnoremap <A-h> :noh <enter>

" popup menu for open buffers
nnoremap <A-o> :buffer<Space><Tab>

" find file
nnoremap <A-S-f> :find<Space>

" search word under cursor in repo using ripgrep
" uses register @a
nnoremap <A-f> "ayiw :execute 'terminal rg ' @a<enter>i

" copy word under cursor to clipboard 
nnoremap <A-c> yiw 

" wishlist
" search and replace

