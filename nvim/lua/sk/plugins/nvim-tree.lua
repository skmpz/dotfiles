return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local nvimtree = require("nvim-tree")

        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- change color of arrows to light blue
        vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

        -- configure nvim-tree
        nvimtree.setup({
            view = {
                preserve_window_proportions = false,
                centralize_selection = true,
            },
            renderer = {
                indent_markers = {
                    enable = true,
                },
            },
            actions = {
                open_file = {
                    resize_window = false,
                },
            }
        })

        -- toggle file explorer
        vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>")

        -- toggle file explorer in current file
        vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>")

        -- collapse everything
        vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>")

        -- refresh
        vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>")
    end,
}
