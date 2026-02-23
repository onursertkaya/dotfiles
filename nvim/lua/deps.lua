local M = {}

function M.install(venv_dir)
  local exists = os.execute("[ -d " .. venv_dir .. " ]") == 0
  if not exists then
    os.execute("python3 -m venv " .. venv_dir)
    os.execute(venv_dir .. "/bin/python3 -m pip install ruff ty")
  end
end

return M
