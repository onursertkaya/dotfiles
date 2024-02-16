vim.g.mapleader = " "

-- floating terminal
vim.keymap.set("n", "<A-enter>", "<CMD>lua require('FTerm').toggle()<CR>")
vim.keymap.set("t", "<A-enter>", "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>")

-- convenience bindings
-- [
vim.keymap.set("n", "<leader><leader>", ":noh<enter>")
vim.keymap.set("n", "<leader>q", ":qa<enter>")
vim.keymap.set("n", "<leader>r", ":%s/<C-R><C-W>//g<Left><Left>")
vim.keymap.set("n", "<leader>h", require("util").yank_current_file_path)
vim.keymap.set("n", "<leader>p", '"_ciw<C-R>0<Esc>')
-- ]

local tls_blt = require("telescope.builtin")

-- pum bindings
-- [
vim.keymap.set("n", "<leader>m", ":map<enter>")
vim.keymap.set("n", "<leader>g", tls_blt.live_grep, {})
vim.keymap.set("n", "<leader>f", tls_blt.find_files, {})
vim.keymap.set("n", "<leader>b", tls_blt.buffers, {})
vim.keymap.set("n", "<leader>d", ":NvimTreeToggle<enter>")
vim.keymap.set("n", "<leader>D", ":NvimTreeFindFile<enter>")
vim.keymap.set("n", "<leader>G", tls_blt.grep_string, {})
vim.keymap.set("n", "<leader>H", function()
    local curr_dir = require("util").get_relative_path()
    tls_blt.live_grep({
        search_dirs = { curr_dir },
        prompt_title = string.format('Grep in [%s]', curr_dir)
    })
end
)
-- ]

-- distinguish delete and cut
vim.keymap.set("v", "d", '"_d')

-- [VISUAL] move blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "H", "<gv")
vim.keymap.set("v", "L", ">gv")

-- [INSERT] mode hjkl
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")


-- [NORMAL]
--   current buffer navigation, CTRL
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-j>", "j<C-e>")
vim.keymap.set("n", "<C-k>", "k<C-y>")

--   buffer management, ALT
vim.keymap.set("n", "<A-q>", ":q<enter>")
vim.keymap.set("n", "<A-S-q>", ":bd<enter>")
vim.keymap.set("n", "<A-w>", ":w<enter>")

--   split navigation, ALT
vim.keymap.set("n", "<A-v>", ":vsplit<enter>") -- open split to right
vim.keymap.set("n", "<A-e>", "<C-W>=<enter>")  -- equalize
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")

--   tab navigation CTRL + ALT
vim.keymap.set("n", "<C-A-l>", ":tabnext<enter>")
vim.keymap.set("n", "<C-A-h>", ":tabprev<enter>")
vim.keymap.set("n", "<C-A-S-l>", ":tabmove +1<enter>")
vim.keymap.set("n", "<C-A-S-h>", ":tabmove -1<enter>")

local M = {}

function M.set_lsp_keymaps(opts)
    local filetype = vim.bo.filetype
    if not require("util").item_in(filetype, { "cpp", "python", "lua", "cuda", "c" }) then
        return
    end

    require("util").log("[remap] setting keymaps for filetype: " .. filetype .. "\n")

    local comppylete = require("comppylete")
    comppylete.setup(opts)

    -- symbol jumps
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gdv", function(o)
        vim.cmd("vs")
        vim.lsp.buf.definition(o)
    end, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gr", function()
        tls_blt.lsp_references({
            layout_strategy = "vertical",
            layout_config = { width = 0.8 },
            path_display = { "tail" }
        })
    end, opts)

    -- diagnostics' jumps
    vim.keymap.set("n", "ge", vim.diagnostic.open_float)
    vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
    vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)

    -- actions
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>ld", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
end

return M
