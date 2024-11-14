return {
    'saecki/crates.nvim',
    tag = 'stable',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('crates').setup {
            completion = {
                cmp = {
                    enabled = true
                }
            }
        }
        require('cmp').setup.buffer({
            sources = { { name = "crates" } }
        })
    end,
}
