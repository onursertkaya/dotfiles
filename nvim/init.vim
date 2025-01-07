" todo
" git blame action in telescope preview
" toggle line/visual comment, language-aware
" harden autocomplete

call plug#begin('~/.nvim_plugged')

" lsp & treesitter
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" ----

" package management
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'williamboman/mason-lspconfig.nvim', { 'do': ':PylspInstall pyls-isort pylsp-mypy python-lsp-black'}
" ----

" user interface
"   PUM (fuzzy) search
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-tree/nvim-web-devicons'

"   lines
Plug 'nvim-lualine/lualine.nvim'

"   git
Plug 'lewis6991/gitsigns.nvim'
" ----

" themes
Plug 'rebelot/kanagawa.nvim'
Plug 'Shadorain/shadotheme'
Plug 'rose-pine/neovim'
Plug 'morhetz/gruvbox'
Plug 'tomasiser/vim-code-dark'
Plug 'sainnhe/everforest'
Plug 'crispybaccoon/dawn.vim'
Plug 'rafamadriz/neon'
Plug 'DanielEliasib/sweet-fusion'

call plug#end()


let g:initvim_path=expand("<sfile>")

lua << EOF
local initvim_path = vim.g["initvim_path"]
package.path = package.path .. ";" .. initvim_path:gsub("init.vim", "lua/config/?.lua")
require("mason_conf")
require("remap")
require("lsp")
require("opts")
require("treesitter")
require("peripherals")
require("gitsigns_conf")
EOF

