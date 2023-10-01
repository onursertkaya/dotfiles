vim.g.mapleader = " "

-- show the mappings
vim.keymap.set("n", "<leader>m", ":map<enter>")

-- floating terminal
vim.keymap.set("n", "<A-enter>", "<CMD>lua require('FTerm').toggle()<CR>")
vim.keymap.set("t", "<A-enter>", "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>")


-- fundamentals, leader
vim.keymap.set("n", "<leader>c", ":noh<enter>")
vim.keymap.set("n", "<leader>q", ":qa<enter>")
vim.keymap.set("n", "<leader>s", ":%s/<C-R><C-W>//g<Left><Left>")

local tls_blt = require("telescope.builtin")
vim.keymap.set("n", "<leader>g", tls_blt.live_grep, {})
vim.keymap.set("n", "<leader>p", tls_blt.find_files, {})
vim.keymap.set("n", "<leader>b", tls_blt.buffers, {})

vim.keymap.set("n", "<leader>d", ":NvimTreeToggle<enter>")
vim.keymap.set("n", "<leader>l", ":NvimTreeFindFile<enter>")


-- distinguish cut & delete
--   in "operator-pending" mode, i.e. for line commands such as yy or dd
-- vim.keymap.set("o", "x", '"0d')
--vim.keymap.set("o", "d", '"_d')
--   in visual mode
vim.keymap.set("v", "d", '"_d')
vim.keymap.set("v", "x", '"0d')
vim.keymap.set("v", "p", '<Esc>i<C-r>0<Esc>') -- (i)nsert mode | <C-r>0 to paste content of 0 

-- paste
vim.keymap.set("n", "p", '"0p')
vim.keymap.set("n", "P", '"0P')


-- move visual blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "H", "<gv")
vim.keymap.set("v", "L", ">gv")

-- insert mode hjkl
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")


-- buffer navigation, CTRL
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-j>", "j<C-e>")
vim.keymap.set("n", "<C-k>", "k<C-y>")


-- buffer management, ALT
vim.keymap.set("n", "<A-q>", ":q<enter>")
vim.keymap.set("n", "<A-S-q>", ":bd<enter>")
vim.keymap.set("n", "<A-w>", ":w<enter>")
-- split navigation, ALT
vim.keymap.set("n", "<A-s>", ":vsplit<enter><C-w>l")
vim.keymap.set("n", "<A-e>", "<C-W>=<enter>")
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")


-- tab navigation CTRL + ALT
vim.keymap.set("n", "<C-A-n>", ":tabnew<enter>")
vim.keymap.set("n", "<C-A-c>", ":tabclose<enter>")
vim.keymap.set("n", "<C-A-l>", ":tabnext<enter>")
vim.keymap.set("n", "<C-A-h>", ":tabprevious<enter>")

local M = {}

function M.set_lsp_keymaps()
    local comppylete = require("comppylete")
    local cpp_py_triggers = {".", "->", "::"}

    for _, t in ipairs(cpp_py_triggers) do
        vim.keymap.set("i", t, comppylete.make_callback_for_omnifunc_invocation(t, false), opts)
    end
    vim.keymap.set("i", "<C-space>", comppylete.make_callback_for_omnifunc_invocation("", false), opts)
    vim.keymap.set("i", "<BS>", comppylete.make_callback_for_omnifunc_invocation("<BS>", true), opts)
    vim.keymap.set("i", "(",  comppylete.make_callback_for_signature_help("("), opts)
    vim.keymap.set("i", ",",  comppylete.make_callback_for_signature_help(","), opts)
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("i", "<C-A-s>", comppylete.insert_signature_help, opts)

    -- normal mode
    --   jumps
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "ge", vim.diagnostic.open_float)
    vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "gn", vim.diagnostic.goto_next)

    --   actions
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { async = true }
    end, opts)

end

return M

