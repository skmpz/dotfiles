return {
    'numToStr/Comment.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('Comment').setup({
            toggler = {
                line = '<leader>c',
                block = 'gbc',
            },
            opleader = {
                line = '<leader>c',
                block = 'gb',
            },
        })
    end,
}
