return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim', build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
        require('telescope').setup {
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
                        ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
                        ['<C-l>'] = require('telescope.actions').select_default, -- open file
                    },
                },
            },
            pickers = {
                find_files = {
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    hidden = true,
                },
            },
            live_grep = {
                file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                additional_args = function(_)
                    return { '--hidden' }
                end,
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'
        -- find files in current directory (recursive)
        vim.keymap.set("n", "<leader>o", "<cmd>Telescope find_files<cr>")

        -- grep word in current directory (recursive)
        vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>")

        -- find word under cursor in current directory (recursive)
        vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch [/] in Open Files' })
    end,
}
