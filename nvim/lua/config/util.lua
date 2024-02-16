local M = {}

function M.feedkeys(key_sequence)
    local key_sequence_vim = vim.api.nvim_replace_termcodes(key_sequence, true, false, true)
    vim.api.nvim_feedkeys(key_sequence_vim, "n", false)
end

function M.log(something)
    local file = io.open("/tmp/comppylete.log", "a")
    if file ~= nil then
        file:write(something .. "\n")
        file:flush()
        file:close()
    else
        print("could not open logfile")
    end
end

function M.replace_nvimtree(name)
    -- replace NvimTree_X to cwd
    if name:sub(1, #"NvimTree_") == "NvimTree_" then
        local full_path = vim.fn.getcwd()
        return full_path:sub(full_path:match("^.*()/") + 1, -1)
    end
    return name
end

local function search_pylint_in_toplevel(root_dir, dir_hint)
    local pylint_files = {}
    for m in vim.fn.globpath(root_dir, dir_hint .. "*/**/pylint"):gmatch("%S+") do
        table.insert(pylint_files, m)
    end
    table.sort(pylint_files)
    if pylint_files == nil then
        return nil
    end
end

function M.greedy_pylint_conf_path()
    local cwd = vim.fn.getcwd()
    if vim.fn.filereadable(cwd .. "/pylint") then
        return cwd .. "/pylint"
    end

    local maybe_under_conf = search_pylint_in_toplevel(cwd, "conf")
    if maybe_under_conf ~= nil then
        return maybe_under_conf[1]
    end

    local last_resort = search_pylint_in_toplevel(cwd, "conf")
    if last_resort ~= nil then
        return last_resort[1]
    end
end

function M.maybe_pylint_args()
    local pylint_args = {}
    local pylint_dir = M.greedy_pylint_conf_path()
    if pylint_dir ~= nil then
        pylint_args = { "--rcfile", pylint_dir }
    end
    return pylint_args
end

function M.yank_current_file_path()
    vim.fn.setreg('"', vim.fn.expand("%p"))
end

function M.item_in(item, tabl)
    for _, elem in ipairs(tabl) do
        if item == elem then
            return true
        end
    end
    return false
end

function M.get_relative_path()
    local cwd = require("nvim-tree.core").get_cwd()
    if cwd == nil then
        return
    end

    local node = require("nvim-tree.api").tree.get_node_under_cursor()
    return require("nvim-tree.utils").path_relative(node.absolute_path, cwd)
end

return M
