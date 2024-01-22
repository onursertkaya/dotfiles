Util = require("util")

-- hide cmdline
vim.opt.cmdheight = 0

require("lualine").setup {
    sections = {
        lualine_c = {
            {
                "searchcount",
                maxcount = 999,
                timeout = 500,
            },
            {
                "filename",
                fmt = function(name, _)
                    return Util.replace_nvimtree(name)
                end
            }
        }
    },
    inactive_sections = {
        lualine_c = {
            {
                "filename",
                fmt = function(name, _)
                    return Util.replace_nvimtree(name)
                end
            }
        },
        lualine_x = { "location" }
    },
    tabline = {
        lualine_a = {
            {
                "tabs",
                tab_max_length = 40,
                max_length = vim.o.columns / 3,
                mode = 1,
                path = 0,
                use_mode_colors = false,
                show_modified_status = true,
                symbols = {
                    modified = "[+]",
                },
                fmt = function(name, context)
                    name = Util.replace_nvimtree(name)

                    local buflist = vim.fn.tabpagebuflist(context.tabnr)
                    local winnr = vim.fn.tabpagewinnr(context.tabnr)
                    local bufnr = buflist[winnr]
                    local mod = vim.fn.getbufvar(bufnr, "&mod")

                    return name .. (mod == 1 and " +" or "")
                end
            }
        }
    }
}

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 40,
    },
    git = {
        timeout = 800,
    },
    filters = {
        -- do not ignore .gitignore files by default
        -- I to toggle
        git_ignored = false,
    },
    renderer = {
        icons = {
            git_placement = "after",
        }
    }
})
