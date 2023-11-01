local util = require("util")

local function make_callback_for_omnifunc_invocation(key, once)
    return function()
        feed_omni = "<C-x><C-o>"
        if (once and (vim.fn.pumvisible() == 0)) then
            -- TODO: use tree sitter to check instead of relying on PUM visibility.
            feed_omni = ""
        end
        util.feedkeys(key .. feed_omni)
    end
end

local function make_callback_for_signature_help(key, while_pumvisible)
    return function()
        util.feedkeys(key)
        if (while_pumvisible and not (vim.fn.pumvisible() == 0)) then
            -- TODO: use tree sitter to check instead of relying on PUM visibility.
            return
        end
        vim.schedule(vim.lsp.buf.signature_help)
    end
end

local function insert_signature_help()
    if vim.api.nvim_get_mode()["mode"] ~= "i" then
        print("insert_signature_help() can only be called while in insert mode")
        return
    end

    local params = require("vim.lsp.util").make_position_params()
    response, err = vim.lsp.buf_request_sync(0, "textDocument/signatureHelp", params)

    if err ~= nil then
        return
    end

    local result = response[1].result
    local signature = result.signatures[1].label
    local startIdx, endIdx = string.find(signature, "%b()")
    local in_parentheses = string.sub(signature, startIdx, endIdx)
    msg = ""
    ctr = 0
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
    local language_omnifunc_triggers = {"."}
    if vim.bo.filetype == "cpp" then
        for _, t in {"::", "->"} do
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
        feed_key, once = unpack(feed)
        vim.keymap.set("i", t, make_callback_for_omnifunc_invocation(feed_key, once), opts)
    end


    -- define signature help triggers
    local signature_help_triggers = { 
        ["<CR>"] = { "<CR>", true },
        ["("] = { "(", false },
        [","] = { ",", false }
    }

    -- set signature help triggers
    for t, feed in pairs(signature_help_triggers) do
        feed_key, while_pumvisible = unpack(feed)
        vim.keymap.set("i", t,  make_callback_for_signature_help(t, while_pumvisible), opts)
    end

    -- insert signature help kwargs, only applies for python
    if vim.bo.filetype == "python" then
        vim.keymap.set("i", "<C-A-s>", insert_signature_help, opts)
    end
end

return M
