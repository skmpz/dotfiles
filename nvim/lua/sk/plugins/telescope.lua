return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "truncate " },
                mappings = {
                    i = {
                        -- move to prev result
                        ["<C-k>"] = actions.move_selection_previous,

                        -- move to next result
                        ["<C-j>"] = actions.move_selection_next,
                    },
                },
            },
        })

        telescope.load_extension("fzf")

        -- find files in current directory (recursive)
        vim.keymap.set("n", "<leader>o", "<cmd>Telescope find_files<cr>")

        -- grep word in current directory (recursive)
        vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>")

        -- find word under cursor in current directory (recursive)
        vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    end,
}
