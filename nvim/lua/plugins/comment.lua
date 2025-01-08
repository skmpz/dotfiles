return {
    'numToStr/Comment.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('Comment').setup({
            toggler = {
                ---Line-comment toggle keymap
                line = '<leader>c',
                ---Block-comment toggle keymap
                block = 'gbc',
            },
            opleader = {
                ---Line-comment keymap
                line = '<leader>c',
                ---Block-comment keymap
                block = 'gb',
            },
        })
    end,
}
