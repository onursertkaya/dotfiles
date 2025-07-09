local M = {}

function M.setup(package_dir)
  require("mason").setup({
    install_root_dir = package_dir,
  })

  if os.execute("type clangd") ~= 0 then
    vim.cmd(":MasonInstall clangd clang-format")
  end
end

return M
