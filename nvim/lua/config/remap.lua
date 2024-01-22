vim.g.mapleader = " "

-- show the mappings
vim.keymap.set("n", "<leader>m", ":map<enter>")

-- floating terminal
vim.keymap.set("n", "<A-enter>", "<CMD>lua require('FTerm').toggle()<CR>")
vim.keymap.set("t", "<A-enter>", "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>")


-- fundamentals, leader
vim.keymap.set("n", "<leader>c", ":noh<enter>")
vim.keymap.set("n", "<leader>q", ":qa<enter>")
vim.keymap.set("n", "<leader>r", ":%s/<C-R><C-W>//g<Left><Left>")

local tls_blt = require("telescope.builtin")


local function get_relative_path()
    local cwd = require("nvim-tree.core").get_cwd()
    if cwd == nil then
        return
    end

    local node = require("nvim-tree.api").tree.get_node_under_cursor()
    return require("nvim-tree.utils").path_relative(node.absolute_path, cwd)
end


vim.keymap.set("n", "<leader>G", tls_blt.live_grep, {})
vim.keymap.set("n", "<leader>H", function()
    local curr_dir = get_relative_path()
    tls_blt.live_grep({
        search_dirs = { curr_dir },
        prompt_title = string.format('Grep in [%s]', curr_dir)
    })
end
)
vim.keymap.set("n", "<leader>h", require("util").yank_current_file_path)
vim.keymap.set("n", "<leader>g", tls_blt.grep_string, {})
vim.keymap.set("n", "<leader>f", tls_blt.find_files, {})
vim.keymap.set("n", "<leader>b", tls_blt.buffers, {})
vim.keymap.set("n", "<leader>d", ":NvimTreeToggle<enter>")
vim.keymap.set("n", "<leader>l", ":NvimTreeFindFile<enter>")


-- distinguish delete and cut
vim.keymap.set("v", "d", '"_d')

-- use _ciw instead of _diwP as the latter behaves differently if replacee word is the last in line.
vim.keymap.set("n", "<leader>p", '"_ciw<C-R>0<Esc>')

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
    if not (filetype == "cpp" or filetype == "python" or filetype == "lua" or filetype == "cuda" or filetype == "c") then
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
        }
        )
    end, opts)

    -- diagnostics' jumps
    vim.keymap.set("n", "ge", vim.diagnostic.open_float)
    vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
    vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)

    -- actions
    vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)

    local format_func = function() vim.lsp.buf.format { async = true } end
    vim.keymap.set("n", "<leader>t", format_func, opts)

    -- disabled, opt for <leader>s instead
    -- vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
end

return M
