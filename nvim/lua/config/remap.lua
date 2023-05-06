vim.g.mapleader = " "

vim.keymap.set("", "<A-g>", ":noh<enter>")

vim.keymap.set("n", "<leader>g", ":Rg<enter>")
vim.keymap.set("n", "<leader>f", ":Files<enter>")

--vim.keymap.set("n", "<leader>p",
--    function()
--        vim.cmd.Lex()
--        --local width = math.floor(0.5 * vim.api.nvim_win_get_width(0))
--        --vim.api.nvim_win_set_width(0, width) 
--    end
--)
vim.keymap.set("n", "<leader>b", ":Buffer<enter>")
vim.keymap.set("n", "<leader>t", ":Windows<enter>")

-- split navigation
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")

-- auto center & "scroll"
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz") 

vim.keymap.set("n", "<C-j>", "<C-e>j")
vim.keymap.set("n", "<C-k>", "<C-y>k") 
