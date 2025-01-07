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

-- default is .wbut, disable (w)indow and (t)ags
o.complete = ".,b,u"

-- default theme & settings
vim.cmd("filetype indent plugin on")
require('kanagawa').setup({
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    theme = "wave",              -- Load "wave" theme when 'background' option is not set
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",           -- try "dragon" !
        light = "lotus"
    },
})
vim.cmd("colorscheme kanagawa")

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
