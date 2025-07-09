local M = {}

local function setup_telescope()
  -- hide cmdline
  vim.opt.cmdheight = 0

  local telescope = require("telescope")
  local tls_util = require("telescope_util")

  telescope.setup({
    pickers = {
      find_files = {
        mappings = {
          i = {
            ["<C-f>"] = tls_util.make_telescope_grep_in_dir_picker(),
          },
        },
      },
    },
    extensions = {
      file_browser = {
        grouped = true,
        dir_icon = "📁",
        hijack_netrw = true,
        mappings = {
          ["i"] = {
            ["<C-f>"] = tls_util.make_telescope_grep_in_dir_picker(),
            ["<C-space>"] = telescope.extensions.file_browser.actions.goto_cwd,
            ["<C-t>"] = require("telescope.actions").select_tab,
          },
        },
      },
    },
  })
  telescope.load_extension("file_browser")
end

local function rename_no_name(name, _)
  return require("util").replace_string_to_cwd(name, "[No Name]")
end

local function tabline_format(name, ctx)
  local bufnr = vim.fn.tabpagebuflist(ctx.tabnr)[vim.fn.tabpagewinnr(ctx.tabnr)]
  if bufnr == require("termit").term_buf then
    return "[T] " .. require("util").get_repo_name()
  elseif vim.bo[bufnr].buftype == "terminal" then
    return "[T] " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  else
    return rename_no_name(name)
  end
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

local function setup_lualine()
  -- https://www.reddit.com/r/neovim/comments/xy0tu1/cmdheight0_recording_macros_message/
  local lualine = require("lualine")
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      lualine.refresh({
        place = { "statusline" },
      })
    end,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      local timer = vim.loop.new_timer()
      timer:start(
        50,
        0,
        vim.schedule_wrap(function()
          lualine.refresh({
            place = { "statusline" },
          })
        end)
      )
    end,
  })

  lualine.setup({
    options = {
      section_separators = "",
      component_separators = "",
    },
    sections = {
      lualine_c = {
        {
          "searchcount",
          maxcount = 999,
          timeout = 500,
        },
        {
          "filename",
          fmt = rename_no_name,
        },
        {
          "macro-recording",
          color = { fg = "#ffaa88", gui = "bold" },
          fmt = show_macro_recording,
        },
      },
    },
    inactive_sections = {
      lualine_c = {
        {
          "filename",
          path = 1,
          fmt = rename_no_name,
        },
      },
      lualine_x = { "location" },
    },
    tabline = {
      lualine_a = {
        {
          "tabs",
          tab_max_length = 40,
          max_length = vim.o.columns,
          mode = 1,
          path = 0,
          use_mode_colors = false,
          show_modified_status = true,
          symbols = {
            modified = "[+]",
          },
          fmt = tabline_format,
        },
      },
    },
  })
end

local function setup_gitsigns()
  require("gitsigns").setup({
    signs = {
      add = { text = "+" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
  })
end

function M.setup()
  setup_telescope()
  setup_lualine()
  setup_gitsigns()
end

return M
