local function plug_llama_cpp_if_available()
  local llm_server = os.getenv("LLM_SERVER")
  if llm_server ~= nil and llm_server ~= "" then
    vim.g.llama_config = { auto_fim = false, endpoint_inst = llm_server }
    local Plug = vim.fn["plug#"]
    Plug("ggml-org/llama.vim")
  end
end

local function plug(devenv_path)
  vim.cmd("packadd! termdebug")

  local Plug = vim.fn["plug#"]

  vim.call("plug#begin", devenv_path .. "/plugged")

  Plug("neovim/nvim-lspconfig")
  Plug("hrsh7th/cmp-nvim-lsp")
  Plug("hrsh7th/cmp-buffer")
  Plug("hrsh7th/cmp-path")
  Plug("hrsh7th/cmp-cmdline")
  Plug("hrsh7th/nvim-cmp")

  Plug("hrsh7th/cmp-vsnip")
  Plug("hrsh7th/vim-vsnip")

  Plug("williamboman/mason.nvim")

  Plug("rebelot/kanagawa.nvim")

  Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

  Plug("nvim-lua/plenary.nvim")
  Plug("nvim-telescope/telescope.nvim", { ["tag"] = "*" })
  Plug("nvim-telescope/telescope-file-browser.nvim")

  Plug("nvim-lualine/lualine.nvim")
  Plug("nvim-tree/nvim-web-devicons")

  Plug("lewis6991/gitsigns.nvim")

  Plug("windwp/nvim-autopairs")

  plug_llama_cpp_if_available()

  vim.call("plug#end")
end

local function update_package_path()
  local config_root = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
  package.path = package.path .. ";" .. config_root .. "lua/?.lua;"
end

local function install_deps_if_needed(devenv_path)
  require("deps").install(devenv_path .. "/lsp_deps")
  require("mason_conf").setup(devenv_path .. "/mason")
end

local function configure(devenv_path)

  require("cmp_conf").setup()
  require("opts").setup()
  require("theme").setup()
  require("treesitter").setup()
  require("peripherals").setup()
  require("remap").setup()
  require("nvim-autopairs").setup()
end

local devenv_path = os.getenv("DEVENV_PATH")

plug(devenv_path)
update_package_path()
install_deps_if_needed(devenv_path)
configure(devenv_path)
