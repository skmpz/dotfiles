return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local nvimtree = require("nvim-tree")

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

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

        vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>")
        vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>")
        vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>")
        vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>")
    end,
}
