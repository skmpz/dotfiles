return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gitsigns = require("gitsigns")
        gitsigns.setup({
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        })

        -- toggle file explorer
        vim.keymap.set("n", "<leader>gn", "<cmd>Gitsigns next_hunk<CR>")
        vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>")
        vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns reset_hunk<CR>")
        vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns preview_hunk<CR>")
    end,
}
