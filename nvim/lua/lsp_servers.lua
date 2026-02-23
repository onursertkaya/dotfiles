local M = {}

function M.configure()
  -- todo: assert on missing cmp_nvim_lsp
  vim.lsp.config.clangd = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }

  vim.lsp.config.ruff = {
    init_options = {
      settings = {
        lineLength = 100,
      },
    },
  }

  vim.lsp.config.ty = {
      settings = {},
  }

end

function M.enable()
  vim.lsp.enable("clangd")
  vim.lsp.enable("ruff")
  vim.lsp.enable("ty")
end

return M
