local o = vim.opt

o.shada = ""

o.splitright = true

o.autoindent = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

vim.g.python_indent = {
    open_paren = 4,
    closed_paren_align_last_line = false
}

o.hlsearch = true
o.incsearch = true

o.ignorecase = true

o.clipboard = "unnamedplus"

o.number = true
o.relativenumber = true

o.showmatch = true
o.mouse = "a"

o.colorcolumn = "100"
o.cursorline = true

o.wildoptions = "pum"
o.wildmode = "full,longest"
o.wildmenu = true

o.switchbuf:append("usetab")

-- do not insert completion suggestions in
-- insert mode eagerly, wait for input.
o.completeopt = "menu,menuone,noinsert"

-- default theme & settings
vim.cmd("filetype indent plugin on")
vim.cmd("colorscheme kanagawa")
o.background = "dark"

-- make <C_n>/<C_p> autocomplete case sensitive
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function()
        o.ignorecase = false
    end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    callback = function()
        o.ignorecase = true
    end,
})
