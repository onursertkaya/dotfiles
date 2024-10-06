-- hide cmdline
vim.opt.cmdheight = 0

local telescope = require("telescope")
local tls_util = require("telescope_util")

telescope.setup {
    pickers = {
        find_files = {
            mappings = {
                i = {
                    ["<C-f>"] = tls_util.make_telescope_grep_in_dir_picker()
                },
            },
        },
    },
    extensions = {
        file_browser = {
            grouped = true,
            dir_icon = "📁",
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                    ["<C-f>"] = tls_util.make_telescope_grep_in_dir_picker(),
                    ["<C-space>"] = telescope.extensions.file_browser.actions.goto_cwd,
                    ["<C-t>"] = require("telescope.actions").select_tab,
                }
            },
        },
    },
}
telescope.load_extension("file_browser")

local function rename_no_name(name, _)
    return require("util").replace_string_to_cwd(name, "[No Name]")
end

local function tabline_format(name, ctx)
    local bufnr = vim.fn.tabpagebuflist(ctx.tabnr)[vim.fn.tabpagewinnr(ctx.tabnr)]
    if bufnr == require("termit").term_buf then
        return " ⚒  "
    else
        return rename_no_name(name)
    end
end

require("lualine").setup {
    options = {
        section_separators = "",
        component_separators = "",
    },
    sections = {
        lualine_c = {
            {
                "searchcount",
                maxcount = 999,
                timeout = 500,
            },
            {
                "filename",
                fmt = rename_no_name,
            }
        }
    },
    inactive_sections = {
        lualine_c = {
            {
                "filename",
                path = 1,
                fmt = rename_no_name,
            }
        },
        lualine_x = { "location" }
    },
    tabline = {
        lualine_a = {
            {
                "tabs",
                tab_max_length = 40,
                max_length = vim.o.columns,
                mode = 1,
                path = 0,
                use_mode_colors = false,
                show_modified_status = true,
                symbols = {
                    modified = "[+]",
                },
                fmt = tabline_format,
            }
        }
    }
}
