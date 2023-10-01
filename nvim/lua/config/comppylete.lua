local util = require("vim.lsp.util")

local M = {}

local function feedkeys(key_sequence)
    local key_sequence_vim = vim.api.nvim_replace_termcodes(key_sequence, true, false, true)
    vim.api.nvim_feedkeys(key_sequence_vim, "n", false)
end

function M.make_callback_for_omnifunc_invocation(key, aa)
    return function()
        feed_omni = "<C-x><C-o>"
        if (aa and (vim.fn.pumvisible() == 0)) then
            feed_omni = ""
        end
        feedkeys(key .. feed_omni)
    end
end

function M.make_callback_for_signature_help(key)
    return function()
        feedkeys(key)
        vim.schedule(vim.lsp.buf.signature_help)
    end
end

function M.insert_signature_help()
    -- TODO: change behavior based on file type
    --       assumes current mode is insert mode, guard against other modes
    --       py: instead of inserting the entire kwargs, fuzzy-suggest in PUM
    local params = util.make_position_params()
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
    feedkeys(msg)
    feedkeys("<Esc>%f,i")
end

return M

