return {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
        require('leap')
        vim.keymap.set('n', 'f', '<Plug>(leap-forward)', {})
        vim.keymap.set('n', 'F', '<Plug>(leap-backward)', {})
    end
}
