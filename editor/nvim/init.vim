set nocompatible            " disable compatibility to old-time vi
set autoindent              " indent a new line the same amount as the line just typed
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set tabstop=4               " number of columns occupied by a tab 

syntax on                   " syntax highlighting
filetype plugin indent on   " allow auto-indenting depending on file type

set clipboard=unnamedplus   " using system clipboard

set hlsearch                " highlight search 
set incsearch               " incremental search
set number                  " add line numbers
set mouse=a                 " enable mouse click


set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set wildmode=longest,list   " get bash-like tab completions
filetype plugin on
set ttyfast                 " Speed up scrolling in Vim

" === unused ===
" set cc=80                  " set an 80 column border for good coding style. (thick bar, ugly)
" set cursorline             " highlight current cursorline. (distracting)


" Useful shortcuts
" w  jump by start of words (punctuation considered words)
" W  jump by words (spaces separate words)
" e  jump to end of words (punctuation considered words)
" E  jump to end of words (no punctuation)
" b  jump backward by words (punctuation considered words)
" B  jump backward by words (no punctuation)
" more: http://www.keyxl.com/aaa8263/290/VIM-keyboard-shortcuts.htm

" Useful combinations
" viw: view inner word
" ciw: change inner word

" TODO:
" add keybindings for
" - jump to symbol n/p * / #
" - toggle for         :set nonumber / :set number
" - clearing highlight :set noh 

