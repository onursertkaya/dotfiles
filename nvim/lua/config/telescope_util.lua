local function launch_mason()
    vim.cmd("Mason")
end

local function telescope_show_mappings()
    require("telescope.builtin").keymaps()
end

local M = {}

function M.telescope_find_directories()
    require("telescope.builtin").find_files({
        find_command = { "find", ".", "-type", "d" },
        prompt_title = "Find Directories"
    })
end

function M.telescope_lsp_refs()
    require("telescope.builtin").lsp_references({
        layout_strategy = "vertical",
        layout_config = { width = 0.8 },
        path_display = { "tail" }
    })
end

function M.telescope_grep_in_dir_cb()
    return function(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        require("telescope.builtin").live_grep({
            search_dirs = { selection[1] },
            prompt_title = string.format("Grep in [%s]", selection[1])
        })
    end
end

local util = require("util")
local normal_mode_actions = {
    { "yank current file path",                  util.yank_current_file_path },
    { "yank current file path as python import", require("py_helpers").yank_py_import_for_current_file_path },
    { "show mappings",                           telescope_show_mappings },
    { "launch mason",                            launch_mason },
    { "yank word under cursor to register", util.yank_word_under_cursor_to_register_interactive },
    { "replace word under cursor in file",  util.replace_word_under_cursor_in_current_buffer },
    { "open word under cursor ...",  util.open_cword_in_external },
}

local visual_mode_actions = {
}

local function custom_actions_entry_maker(entry)
    return {
        value = entry,
        display = entry[1],
        ordinal = entry[1],
        cb = entry[2]
    }
end

function M.telescope_actions_picker_cb(mode)
    assert(util.item_in(mode, {"n", "v"}))
    local mode_actions = mode == "n" and normal_mode_actions or visual_mode_actions

    return function(opts)
        local actions = require "telescope.actions"
        opts = opts or {}

        require("telescope.pickers").new(opts, {
            prompt_title = "Actions",
            finder = require("telescope.finders").new_table {
                results = mode_actions,
                entry_maker = custom_actions_entry_maker
            },
            sorter = require("telescope.config").values.generic_sorter(opts),
            layout_strategy = "vertical",
            layout_config = { width = 0.2, height = 0.2 },
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    selection.cb()
                end)
                return true
            end,
        }):find()
    end
end

return M
