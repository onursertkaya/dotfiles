local M = {}

function M.feedkeys(key_sequence)
    local key_sequence_vim = vim.api.nvim_replace_termcodes(key_sequence, true, false, true)
    vim.api.nvim_feedkeys(key_sequence_vim, "n", false)
end

return M
