local util = require("util")
local ts_utils = require("nvim-treesitter.ts_utils")


local function is_current_cursor_word_an_identifier()
    -- to debug, use root:range(false), treesitter and vim.api has off-by-1 indexing.
    local root = ts_utils.get_node_at_cursor()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    local node_at_cursor = root:named_descendant_for_range(r - 1, c - 1, r - 1, c - 1)

    return node_at_cursor and node_at_cursor:type() == "identifier"
end

local function make_callback_for_omnifunc_invocation(key, invoke_once)
    return function()
        local pum_visible = (vim.fn.pumvisible() == 0)
        local identifier = is_current_cursor_word_an_identifier()

        local feed_omni = "<C-x><C-o>"
        if ((not identifier) or (invoke_once and pum_visible)) then
            feed_omni = ""
        end
        util.feedkeys(key .. feed_omni)
    end
end

local function make_callback_for_signature_help(key, invoke_while_pumvisible)
    return function()
        util.feedkeys(key)
        local pum_visible = (vim.fn.pumvisible() == 0)
        local identifier = is_current_cursor_word_an_identifier()

        if ((not identifier) or (invoke_while_pumvisible and not pum_visible)) then
            return
        end
        vim.schedule(vim.lsp.buf.signature_help)
    end
end

local function make_callback_for_clangd_header_source_jump()
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

function M.setup(opts)
    -- define language triggers
    local language_omnifunc_triggers = { "." }
    if vim.bo.filetype == "cpp" then
        for _, t in ipairs({ "::", "->" }) do
            table.insert(language_omnifunc_triggers, t)
        end
    end

    -- set language triggers
    for _, t in ipairs(language_omnifunc_triggers) do
        vim.keymap.set("i", t, make_callback_for_omnifunc_invocation(t, false), opts)
    end

    -- define generic triggers
    local generic_omnifunc_triggers = {
        ["<C-space>"] = { "", false },
        ["<BS>"] = { "<BS>", true }
    }

    -- set generic triggers
    for t, feed in pairs(generic_omnifunc_triggers) do
        local feed_key, once = unpack(feed)
        vim.keymap.set("i", t, make_callback_for_omnifunc_invocation(feed_key, once), opts)
    end


    -- define signature help triggers
    local signature_help_triggers = {
        ["<CR>"] = { true },
        ["("] = { false },
        [","] = { false }
    }

    -- set signature help triggers
    for t, while_pumvisible in pairs(signature_help_triggers) do
        vim.keymap.set("i", t, make_callback_for_signature_help(t, while_pumvisible), opts)
    end

    if vim.bo.filetype == "python" then
        vim.keymap.set("i", "<C-A-s>", insert_signature_help, opts)
    elseif vim.bo.filetype == "cpp" then
        vim.keymap.set("n", "gh", make_callback_for_clangd_header_source_jump(), opts)
    end
end

return M
