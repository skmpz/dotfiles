-- disable mouse
vim.o.mouse = ''

-- clipboard
vim.o.clipboard = 'unnamedplus'

-- disable highlight on search
vim.o.hlsearch = false

-- incremental search
vim.o.incsearch = true

-- enable cursorline
vim.o.cursorline = true

-- enable number and relative
vim.wo.number = true
vim.wo.relativenumber = true

-- enable breakindent
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- decrease updatetime
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- case insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

-- spaces for tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- split right/below
vim.o.splitright = true
vim.o.splitbelow = true

-- show trailing spaces
vim.o.list = true
vim.o.listchars = 'tab:>-,trail:~,extends:>,precedes:<'

-- disable swapfile
vim.o.swapfile = false

-- faster scrolling
vim.o.lazyredraw = true

-- Set colorscheme
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
