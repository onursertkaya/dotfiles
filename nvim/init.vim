call plug#begin('~/.nvim_plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }

Plug 'numToStr/FTerm.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-tree.lua'

Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'ojroques/nvim-hardline'
Plug 'lewis6991/gitsigns.nvim'

Plug 'rose-pine/neovim'
Plug 'morhetz/gruvbox'
Plug 'tomasiser/vim-code-dark'
Plug 'sainnhe/everforest'
Plug 'crispybaccoon/dawn.vim'
Plug 'rafamadriz/neon'

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
require("nvimtree")
require("hardlinebar_conf")
require("gitsigns_conf")
EOF

