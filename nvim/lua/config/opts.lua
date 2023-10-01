local o = vim.opt

o.shada = ""

o.splitright = true

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

o.colorcolumn = "100"

-- mostly obsolete due to fzf.vim
o.path = "**"

o.wildoptions = "pum,fuzzy"
o.wildmode = "full,longest"
o.wildmenu = true

-- do not insert completion suggestions in
-- insert mode eagerly, wait for input. 
o.completeopt = "menu,noinsert"


-- default theme & settings
vim.cmd("filetype indent plugin on")
--vim.cmd("colorscheme rose-pine")
vim.cmd("colorscheme gruvbox")
o.background = "dark"

-- filetype aware themes
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.py"},
  callback = function()
    --vim.g.everforest_background = "hard"
    --vim.cmd([[colorscheme everforest]])
    
    --vim.cmd("colorscheme dawn")

    vim.cmd("colorscheme codedark")

    --vim.g.neon_bold = true
    --vim.g.neon_style = "dark"
    --vim.cmd("colorscheme neon")
  end,
})
