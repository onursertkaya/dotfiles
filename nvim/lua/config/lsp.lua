local lspconfig = require("lspconfig")
local remap = require("remap")

-- disable virtual text
vim.diagnostic.config({ virtual_text = false })

---- for enhanced debugging
-- vim.lsp.set_log_level 'debug'
-- if vim.fn.has 'nvim-0.5.1' == 1 then
--   require('vim.lsp.log').set_format_func(vim.inspect)
-- end

lspconfig.clangd.setup {
    cmd = { "clangd" },
    root_dir = lspconfig.util.root_pattern(".git")
}

local pylint_args = require("util").maybe_pylint_args()
lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                -- since pycodestyle does not have
                -- pyproject.toml support, bump the
                -- line length to 100 here.
                pycodestyle = {
                    ignore = { "E203", "W503" },
                    maxLineLength = 100
                },
                pylint = {
                    enabled = true,
                    args = pylint_args
                }
            }
        }
    }
}

lspconfig.ruff_lsp.setup {}

lspconfig.lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
    end
}

vim.api.nvim_create_autocmd("LspAttach", {
    pattern = { "*.c", "*.cpp", "*.h", "*.cu", "*.py", "*.lua" },
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local buffer_opts = { buffer = ev.buf }
        remap.set_lsp_keymaps(buffer_opts)
    end,
})
