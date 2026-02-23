let g:devenv_path='$DEVENV_PATH'
let g:initvim_path=expand("<sfile>")

call plug#begin(devenv_path .. '/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'williamboman/mason.nvim'

Plug 'rebelot/kanagawa.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '*' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'lewis6991/gitsigns.nvim'

call plug#end()

packadd! termdebug

lua << EOF
  local initvim_path = vim.g["initvim_path"]
  package.path = package.path .. ";" .. initvim_path:gsub("init.vim", "lua/?.lua")

  local devenv_path = os.getenv(vim.g["devenv_path"]:sub(2))  -- skip the preceding $

  local deps = require("deps")
  deps.install(devenv_path  .. "/lsp_deps")
  require("cmp_conf").setup()
  require("mason_conf").setup(devenv_path .. "/mason")
  require("opts").setup()
  require("theme").setup()
  require("treesitter").setup()
  require("peripherals").setup()
  require("remap").setup()
EOF
