require 'core.options'
require 'core.keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    require 'plugins.colorscheme',
    require 'plugins.comment',
    require 'plugins.crates',
    require 'plugins.dressing',
    require 'plugins.gitsigns',
    require 'plugins.harpoon',
    require 'plugins.leap',
    require 'plugins.lsp',
    require 'plugins.lualine',
    require 'plugins.nvim-autopairs',
    require 'plugins.nvim-cmp',
    require 'plugins.nvim-metals',
    require 'plugins.nvim-tabline',
    require 'plugins.nvim-telescope',
    require 'plugins.nvim-tree',
    require 'plugins.nvim-treesitter',
    require 'plugins.rustaceanvim',
})
