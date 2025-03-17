local util = require("util")
local ts_utils = require("nvim-treesitter.ts_utils")

local function get_node_at_cursor()
    -- to debug, use root:range(false), treesitter and vim.api has off-by-1 indexing.
    local root = ts_utils.get_node_at_cursor()
    if root == nil then
        return nil
    end

    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    local node_at_cursor = root:named_descendant_for_range(r - 1, c - 1, r - 1, c - 1)
    return node_at_cursor
end

local function is_current_cursor_an_argument()
    local node_at_cursor = get_node_at_cursor()
    if node_at_cursor == nil then
        return false
    end

    local within_function_call = false
    local current_node = node_at_cursor
    while current_node do
        if util.item_in(current_node:type(), { "keyword_argument", "argument_list", "field_identifier", "init_declarator" }) then
            within_function_call = true
            break
        end
        current_node = current_node:parent()
    end

    return within_function_call
end


local function is_current_cursor_word_an_identifier()
    local node_at_cursor = get_node_at_cursor()
    if node_at_cursor == nil then
        return false
    end

    return node_at_cursor and util.item_in(node_at_cursor:type(), {
        -- closing parenthesis, for temporaries
        "argument_list",

        -- scope variables, python classes
        "identifier",

        -- cpp classes/structs
        "type_identifier",

        -- cpp {}
        "initializer_list",

        -- ?
        "compound_statement",

        -- python import / from .* import .*
        "import_from_statement",
        "import_statement"
    })
end

local function is_pum_visible()
    return vim.fn.pumvisible() == 1
end

local function make_clangd_header_source_jumper()
    return function()
        vim.cmd("ClangdSwitchSourceHeader")
    end
end

local function make_signature_helper(key, invoke_only_while_pumvisible)
    return function()
        util.feedkeys(key)
        local identifier = is_current_cursor_an_argument() or is_current_cursor_word_an_identifier()

        if (identifier and (not invoke_only_while_pumvisible or not is_pum_visible())) then
            vim.schedule(vim.lsp.buf.signature_help)
        end
    end
end

local function insert_signature_help()
    if vim.api.nvim_get_mode()["mode"] ~= "i" then
        print("insert_signature_help() can only be called while in insert mode")
        return
    end

    local params = require("vim.lsp.util").make_position_params()
    local response, err = vim.lsp.buf_request_sync(0, "textDocument/signatureHelp", params)

    if err ~= nil then
        return
    end

    local result = response[1].result
    local signature = result.signatures[1].label
    local startIdx, endIdx = string.find(signature, "%b()")
    local in_parentheses = string.sub(signature, startIdx, endIdx)
    local msg = ""
    local ctr = 0
    for lhs in string.gmatch(in_parentheses, "(%w+):%s%w+") do
        msg = msg .. (lhs .. "=, ")
        ctr = ctr + 1
    end
    if ctr == 1 then
        msg = msg:sub(0, -2)
    end
    msg = msg .. ")"
    util.feedkeys(msg)
    util.feedkeys("<Esc>%f,i")
end

local function get_lsp_completions()
    local results = vim.lsp.buf_request_sync(0, 'textDocument/completion', vim.lsp.util.make_position_params(), 1000)

    local items = {}
    for _, response in pairs(results or {}) do
        if response and response.result then
            local result = response.result

            if result.items then
                vim.list_extend(items, result.items)
            elseif vim.tbl_islist(result) then
                vim.list_extend(items, result)
            end
        end
    end

    return items
end

local function format_completions(items, line_width, replace_cword)
    local completion_item_kind = {
        "Text",
        "Method",
        "Function",
        "Constructor",
        "Field",
        "Variable",
        "Class",
        "Interface",
        "Module",
        "Property",
        "Unit",
        "Value",
        "Enum",
        "Keyword",
        "Snippet",
        "Color",
        "File",
        "Reference",
        "Folder",
        "EnumMember",
        "Constant",
        "Struct",
        "Event",
        "Operator",
        "TypeParameter"
    }
    local make_line = function(item)
        local label = item.label
        local kind = completion_item_kind[item.kind]
        local spaces = string.rep(" ", line_width - (label:len() + kind:len()))
        return label .. spaces .. kind
    end

    local telescope_entries = {}
    local pre_action = replace_cword and "ciw" or "a"
    for _, item in ipairs(items) do
        local text = make_line(item)
        local inserter = function()
            util.feedkeys(pre_action .. item.insertText)
        end
        table.insert(telescope_entries, { text, inserter })
    end
    return telescope_entries
end

local function make_telescope_omni_completion_picker(opts, pre_insert)
    local line_width = 100
    local should_replace_cword = pre_insert == nil
    return function()
        if not is_current_cursor_word_an_identifier() then
            -- after = false
            -- follow = true
            vim.api.nvim_put({ pre_insert }, "c", false, true)
            return
        end

        -- a trigger-token invoked this function, insert it immediately
        if not should_replace_cword then
            -- after = true
            -- follow = true
            vim.api.nvim_put({ pre_insert }, "c", false, true)
        end

        local width_offset = 6
        local final_line_width = line_width + width_offset
        opts = opts or {}

        local entry_maker = function(entry)
            return {
                value = entry,
                display = entry[1],
                ordinal = entry[1],
                cb = entry[2]
            }
        end

        local maybe_completions = get_lsp_completions()
        if next(maybe_completions) ~= nil then
            require("telescope_util").pick(
                opts,
                format_completions(maybe_completions, line_width, should_replace_cword),
                entry_maker,
                final_line_width,
                0.33,
                "Hint",
                "Matches",
                "cursor"
            )
        end
    end
end

local function is_cpp_file(filetype)
    return util.item_in(filetype, { "cpp", "cuda" })
end

local function set_signature_help_triggers(filetype, opts)
    -- todo: keep PUM open until the matching character >}) is pressed.
    local height = 45
    local width = 120
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            relative = "cursor",
            border = "rounded",
            height = height,
            width = width,
            fixed = true,
        }
    )

    local common_triggers = {
        ["<CR>"] = { true },
        ["("] = { false },
        [","] = { false },
    }

    local set_triggers = function(trigger_map)
        for t, while_pumvisible in pairs(trigger_map) do
            vim.keymap.set("i", t, make_signature_helper(t, while_pumvisible), opts)
        end
    end

    set_triggers(common_triggers)

    local cpp_triggers = {
        ["{"] = { false },
        ["<"] = { false },
    }
    if is_cpp_file(filetype) then
        set_triggers(cpp_triggers)
    end
end

local function set_completion_triggers(filetype, opts)
    -- do not trigger with <Alt + .>
    vim.keymap.set("i", "<A-.>", function() vim.api.nvim_put({ "." }, "c", false, true) end, opts)

    -- explicitly trigger with Ctrl + space on symbols
    vim.keymap.set("i", "<C-space>", make_telescope_omni_completion_picker(opts, nil), opts)

    -- trigger with . on symbols
    vim.keymap.set("i", ".", make_telescope_omni_completion_picker(opts, "."), opts)

    -- trigger with specific symbols
    if is_cpp_file(filetype) then
        for _, t in ipairs({ "::", "->" }) do
            vim.keymap.set("i", t, make_telescope_omni_completion_picker(opts, t), opts)
        end
    end
end

local function set_language_specific_functionality(filetype, opts)
    if filetype == "python" then
        vim.keymap.set("i", "<C-A-s>", insert_signature_help, opts)
    elseif is_cpp_file(filetype) then
        vim.keymap.set("n", "gh", make_clangd_header_source_jumper(), opts)
    end
end

local M = {}

function M.setup(opts)
    set_signature_help_triggers(opts)

    local filetype = vim.bo.filetype
    set_completion_triggers(filetype, opts)
    set_language_specific_functionality(filetype, opts)
end

return M
