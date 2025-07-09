local util = require("util")

local M = {}

function M.yank_py_import_for_current_file_path()
  local filepath = util.current_file_path()
  if not util.endswith(filepath, ".py") then
    return
  end

  local import_st = "from " .. filepath:gsub("/", "."):sub(0, #filepath - 3) .. " import "
  util.set_clipboard(import_st)
end

return M
