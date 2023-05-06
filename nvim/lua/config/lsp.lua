local lspconfig = require("lspconfig")
lspconfig.clangd.setup {
    cmd = {"clangd-12"},
}

lspconfig.pylsp.setup {
    cmd = {"pylsp"},
}

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<space>p", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<space>n", vim.diagnostic.goto_next)

vim.diagnostic.config({
  virtual_text = false
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }

        -- py & cpp member access
        vim.keymap.set("i", ".", function()
            local dot = vim.api.nvim_replace_termcodes(".<C-x><C-o>", true, false, true)
            vim.api.nvim_feedkeys(dot, "n", false)
        end, opts)

        -- cpp ptr member access
        vim.keymap.set("i", "->", function()
            local arrow = vim.api.nvim_replace_termcodes("-><C-x><C-o>", true, false, true)
            vim.api.nvim_feedkeys(arrow, "n", false)
        end, opts)

        -- cpp namespace
        vim.keymap.set("i", "::", function()
            local namespace = vim.api.nvim_replace_termcodes("::<C-x><C-o>", true, false, true)
            vim.api.nvim_feedkeys(namespace, "n", false)
        end, opts)

        -- backspace should invoke omni completion if popupmenu was already visible
        vim.keymap.set("i", "<BS>", function()
            if vim.fn.pumvisible() > 0 then
                local backspace = vim.api.nvim_replace_termcodes("<BS><C-x><C-o>", true, false, true)
                vim.api.nvim_feedkeys(backspace, "n", false)
            else
                local backspace = vim.api.nvim_replace_termcodes("<BS>", true, false, true)
                vim.api.nvim_feedkeys(backspace, "n", false)
            end
        end, opts)

        vim.keymap.set("n", "gd", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        --vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        --vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        --vim.keymap.set("n", "<space>wl", function()
        --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        -- vim.keymap.set("n", "<space>f", function()
        --     vim.lsp.buf.format { async = true }
        -- end, opts)
    end,
})
