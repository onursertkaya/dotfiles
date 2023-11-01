local lspconfig = require("lspconfig")
local remap = require("remap")

---- for enhanced debugging
-- vim.lsp.set_log_level 'debug'
-- if vim.fn.has 'nvim-0.5.1' == 1 then
--   require('vim.lsp.log').set_format_func(vim.inspect)
-- end

lspconfig.clangd.setup {
    cmd = {"clangd"},
}

lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {"E203"},
                    maxLineLength = 100
                },
                yapf = {
                    enabled = false
                },
                --pylint = {
                --    enabled = true
                --}
                --flake8 = {
                --    enabled = true
                --},
                --pydocstyle = {
                --    enabled = true
                --}
            }
        }
    }
}

lspconfig.ruff_lsp.setup {
  on_attach = on_attach,
  init_options = {
    settings = {
      args = {},
    }
  }
}

vim.diagnostic.config({ virtual_text = false })


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local buffer_opts = { buffer = ev.buf }
        remap.set_lsp_keymaps(buffer_opts)
    end,
})
