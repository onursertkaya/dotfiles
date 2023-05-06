call plug#begin('~/.nvim_plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'ojroques/nvim-hardline'

Plug 'rose-pine/neovim'
Plug 'tomasiser/vim-code-dark'

call plug#end()

let g:initvim_path=expand("<sfile>")

lua << EOF
local initvim_path = vim.g["initvim_path"]
package.path = package.path .. ";" .. initvim_path:gsub("init.vim", "lua/config/?.lua")
require("remap")
require("lsp")
require("netrw")
require("opts")
require("treesitter")
require("hardline-bar")
EOF

