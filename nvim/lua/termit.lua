local M = {}

M.term_buf = nil
M.prev_buf = nil

-- TODO: if terminal instance is killed there's no way to respawn

local function is_active()
  return vim.fn.expand("%") == "termit_main"
end

local function is_visible_in_tab()
  for _, tp in ipairs(vim.api.nvim_list_tabpages()) do
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tp)) do
      if vim.api.nvim_win_get_buf(window) == M.term_buf then
        return true
      end
    end
  end
  return nil
end

function M.termit_global()
  if M.term_buf == nil then
    M.prev_buf = vim.api.nvim_get_current_buf()
    M.term_buf = vim.api.nvim_create_buf(true, false)
    vim.cmd(string.format("$tabnew | buffer %s | terminal", M.term_buf))
    vim.cmd("file termit_main")
  else
    if is_active() and M.prev_buf ~= nil then
      vim.cmd(string.format("sbuffer %s", M.prev_buf))
    else
      M.prev_buf = vim.api.nvim_get_current_buf()
      if is_visible_in_tab() then
        -- sbuffer works due to o.switchbuf:append("usetab"), then move to rightmost
        vim.cmd(string.format("sbuffer %s | $tabmove", M.term_buf))
      else
        -- open to rightmost
        vim.cmd(string.format("$tabnew | buffer %s ", M.term_buf))
      end
    end
  end
end

function M.termit_new()
  vim.ui.input({ prompt = "Terminal name: " }, function(term_name)
    vim.cmd("tabnew | terminal")
    vim.cmd("file termit_" .. term_name)
  end)
end

return M
