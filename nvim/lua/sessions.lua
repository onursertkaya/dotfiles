local function vim_session_dir()
  local dir = os.getenv("HOME") .. "/.vimsessions/"
  os.execute("mkdir -p " .. dir)
  return dir
end

local M = {}

function M.save_session()
  vim.ui.input({ prompt = "Session name: " }, function(session_name)
    vim.cmd("mksession! " .. vim_session_dir() .. session_name .. ".vim")
  end)
end

function M.restore_session(session_filename)
  vim.cmd.source(vim_session_dir() .. session_filename)
end

function M.get_saved_sessions()
  local proc = io.popen("ls " .. vim_session_dir(), "r")
  local stdout = proc:read("*a")

  local lines = {}
  for s in stdout:gmatch("[^\n]+") do
    table.insert(lines, s)
  end
  return lines
end

return M
