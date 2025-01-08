-- set leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('', '<Space>', '<Nop>', { noremap = true, silent = true })

-- : for ;
vim.keymap.set('', ';', ':', { noremap = true, silent = false })
vim.keymap.set('', ':', ',', { noremap = true, silent = false })
vim.keymap.set('', ',', ';', { noremap = true, silent = false })

-- write and quit with leader+w/q
vim.keymap.set('', '<leader>q', ':q<CR>', { noremap = true, silent = false })
vim.keymap.set('', '<leader>w', ':w<CR>', { noremap = true, silent = false })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- search with s/S
vim.keymap.set('', 's', '/', { noremap = true })
vim.keymap.set('', 'S', '?', { noremap = true })

-- remap for word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- create session
vim.keymap.set('n', '<leader>,', ':mks! ~/.sess<CR>', { noremap = true })

-- go to end of line and enter insert mode
vim.keymap.set('i', 'jk', '<ESC>A', { noremap = true, silent = true })

-- indent right after pasting and visual select last inserted text
vim.keymap.set('', 'gV', '`[V`]', { noremap = true })
vim.keymap.set('', 'p', 'pgV=', { noremap = false })

-- move visual text multiple times
vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })

-- use arrow keys to resize windows
vim.keymap.set('', '<up>', '<C-W>+', { noremap = true })
vim.keymap.set('', '<down>', '<C-W>-', { noremap = true })
vim.keymap.set('', '<left>', '3<C-W><', { noremap = true })
vim.keymap.set('', '<right>', '3<C-W>>', { noremap = true })

-- " navigation between splits
vim.keymap.set('', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.keymap.set('', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.keymap.set('', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.keymap.set('', '<C-H>', '<C-W><C-H>', { noremap = true })
vim.keymap.set('', '<C-Down>', '<C-W><C-J>', { noremap = true })
vim.keymap.set('', '<C-Up>', '<C-W><C-K>', { noremap = true })
vim.keymap.set('', '<C-Left>', '<C-W><C-H>', { noremap = true })
vim.keymap.set('', '<C-Right>', '<C-W><C-L>', { noremap = true })
vim.keymap.set('', '<leader>i', '<C-O>', { noremap = true })

-- tab navigation
vim.keymap.set('', 'tl', ':tabnext<CR>', { noremap = true, silent = false })
vim.keymap.set('', 'th', ':tabprev<CR>', { noremap = true, silent = false })

-- map ctrl-{hjkl} to move in insert mode
vim.keymap.set('i', '<C-H>', '<Left>', { noremap = true })
vim.keymap.set('i', '<C-J>', '<Down>', { noremap = true })
vim.keymap.set('i', '<C-K>', '<Up>', { noremap = true })
vim.keymap.set('i', '<C-L>', '<Right>', { noremap = true })

-- go to the end of what copied/pasted and no overwrite
vim.keymap.set('v', 'y', 'y`]', { noremap = true, silent = true })
vim.keymap.set('v', 'p', 'p`]', { noremap = true, silent = true })
vim.keymap.set('n', 'p', 'p`]', { noremap = true, silent = true })
vim.keymap.set('x', 'p', 'pgvy`]', { noremap = true, silent = true })

-- diagnostics navigation
vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next, { noremap = true, silent = true })
