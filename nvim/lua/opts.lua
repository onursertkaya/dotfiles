local M = {}

function M.setup()
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
    closed_paren_align_last_line = false,
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

  o.switchbuf:append("usetab")
end

return M
