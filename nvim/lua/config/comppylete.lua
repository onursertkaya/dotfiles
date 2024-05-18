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

local function omnifunc_invocation_cb(key, invoke_once)
    return function()
        local identifier = is_current_cursor_word_an_identifier()

        local feed_omni = ""
        if (identifier and (not invoke_once or is_pum_visible())) then
            feed_omni = "<C-x><C-o>"
        end
        util.feedkeys(key .. feed_omni)
    end
end

local function signature_help_cb(key, invoke_while_pumvisible)
    return function()
        util.feedkeys(key)
        local identifier = is_current_cursor_an_argument() or is_current_cursor_word_an_identifier()

        if (identifier and (not invoke_while_pumvisible or not is_pum_visible())) then
            vim.schedule(vim.lsp.buf.signature_help)
        end
    end
end

local function clangd_header_source_jump_cb()
    return function()
        vim.cmd("ClangdSwitchSourceHeader")
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

local M = {}

local function language_specific_triggers(filetype, opts)
    local language_omnifunc_triggers = { "." }
    if util.item_in(filetype, { "cpp", "cuda" }) then
        for _, t in ipairs({ "::", "->" }) do
            table.insert(language_omnifunc_triggers, t)
        end
    end

    for _, t in ipairs(language_omnifunc_triggers) do
        vim.keymap.set("i", t, omnifunc_invocation_cb(t, false), opts)
    end
end

local function generic_triggers(opts)
    -- define generic triggers
    local generic_omnifunc_triggers = {
        ["<C-space>"] = { "", false },
        ["<BS>"] = { "<BS>", true }
    }

    -- set generic triggers
    for t, feed in pairs(generic_omnifunc_triggers) do
        local feed_key, once = unpack(feed)
        vim.keymap.set("i", t, omnifunc_invocation_cb(feed_key, once), opts)
    end
end

local function signature_help_triggers(opts)
    -- define signature help triggers
    local triggers = {
        ["<CR>"] = { true },
        ["("] = { false },
        ["{"] = { false },
        [","] = { false }
    }

    -- set signature help triggers
    for t, while_pumvisible in pairs(triggers) do
        vim.keymap.set("i", t, signature_help_cb(t, while_pumvisible), opts)
    end
end

local function language_specific_functionality(filetype, opts)
    if filetype == "python" then
        vim.keymap.set("i", "<C-A-s>", insert_signature_help, opts)
    elseif util.item_in(filetype, { "cpp", "cuda" }) then
        vim.keymap.set("n", "gh", clangd_header_source_jump_cb(), opts)
    end
end

function M.setup(opts)
    generic_triggers(opts)
    signature_help_triggers(opts)

    local filetype = vim.bo.filetype
    language_specific_triggers(filetype, opts)
    language_specific_functionality(filetype, opts)
end

return M
