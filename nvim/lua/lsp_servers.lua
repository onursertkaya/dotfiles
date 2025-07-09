local M = {}

function M.configure()
  -- todo: assert on missing cmp_nvim_lsp
  vim.lsp.config.clangd = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }

  vim.lsp.config.pylsp = {
    settings = {
      pylsp = {
        plugins = {
          jedi_completion = { enabled = true },
          jedi_definition = { enabled = true },
          jedi_hover = { enabled = true },
          jedi_references = { enabled = true },
          jedi_signature_help = { enabled = true },
          jedi_symbols = { enabled = true },
        },
      },
    },
  }

  vim.lsp.config.ruff = {
    init_options = {
      settings = {
        lineLength = 100,
      },
    },
  }

  vim.lsp.config.ty = {
    init_options = {
      settings = {},
    },
  }
end

function M.enable()
  vim.lsp.enable("clangd")
  vim.lsp.enable("pylsp")
  vim.lsp.enable("ruff")
  vim.lsp.enable("ty")
end

return M
