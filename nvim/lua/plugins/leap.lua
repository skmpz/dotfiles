return {
    'ggandor/leap.nvim',
    config = function()
        require('leap')
        -- Manually configure trigger key
        vim.keymap.set('n', 'f', '<Plug>(leap-forward)', {})
        vim.keymap.set('n', 'F', '<Plug>(leap-backward)', {})
    end
}
