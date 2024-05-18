local util = require("util")

local function search_pylint_in_toplevel(root_dir, dir_hint)
    local pylint_files = {}
    for m in vim.fn.globpath(root_dir, dir_hint .. "*/**/pylint"):gmatch("%S+") do
        table.insert(pylint_files, m)
    end
    table.sort(pylint_files)
    if next(pylint_files) == nil then
        return nil
    end
    return pylint_files[1]
end

local function greedy_pylint_conf_path()
    local cwd = vim.fn.getcwd()
    if vim.fn.filereadable(cwd .. "/pylint") ~= 0 then
        return cwd .. "/pylint"
    end

    return search_pylint_in_toplevel(cwd, "conf")
end

local M = {}

function M.maybe_pylint_args()
    local pylint_args = {}
    local pylint_path = greedy_pylint_conf_path()
    if pylint_path ~= nil then
        pylint_args = { "--rcfile " .. pylint_path }
    end
    return pylint_args
end

function M.yank_py_import_for_current_file_path()
    local filepath = util.current_file_path()
    if not util.endswith(filepath, ".py") then
        return
    end

    local import_st = "from " .. filepath:gsub("/", "."):sub(0, #filepath - 3) .. " import "
    util.set_clipboard(import_st)
end

return M
