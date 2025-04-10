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
                        ['<C-k>'] = require('telescope.actions').move_selection_previous,
                        ['<C-j>'] = require('telescope.actions').move_selection_next,
                        ['<C-l>'] = require('telescope.actions').select_default,
                    },
                },
                file_ignore_patterns = {
                    -- Files
                    "%.a",
                    "%.class",
                    "%.jpeg",
                    "%.jpg",
                    "%.log",
                    "%.mkv",
                    "%.mp4",
                    "%.o",
                    "%.out",
                    "%.pdf",
                    "%.png",
                    "%.semanticdb",
                    "%.tasty",
                    "%.zip",
                    -- Directories
                    ".cache",
                    ".git/",
                    ".metals/",
                    ".bloop/",
                    ".github/",
                    ".node_modules/",
                    "target/",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
            },
            live_grep = {
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

        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'

        vim.keymap.set("n", "<leader>o", "<cmd>Telescope find_files<cr>")
        vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>")
        vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch [/] in Open Files' })
    end,
}
