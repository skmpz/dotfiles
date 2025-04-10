return { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            dependencies = {
                {
                    'rafamadriz/friendly-snippets',
                    config = function()
                        require('luasnip.loaders.from_vscode').lazy_load()
                    end,
                },
            },
        },
        'saadparwaiz1/cmp_luasnip',
        "onsails/lspkind.nvim",
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
    },
    config = function()

        local kind_icons = {
            Text = '󰉿',
            Method = 'm',
            Function = '󰊕',
            Constructor = '',
            Field = '',
            Variable = '󰆧',
            Class = '󰌗',
            Interface = '',
            Module = '',
            Property = '',
            Unit = '',
            Value = '󰎠',
            Enum = '',
            Keyword = '󰌋',
            Snippet = '',
            Color = '󰏘',
            File = '󰈙',
            Reference = '',
            Folder = '󰉋',
            EnumMember = '',
            Constant = '󰇽',
            Struct = '',
            Event = '',
            Operator = '󰆕',
            TypeParameter = '󰊄',
        }
        -- See `:help cmp`
        local lspkind = require('lspkind')
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },

            mapping = cmp.mapping.preset.insert {
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<CR>'] = cmp.mapping.confirm { select = true },
                ['<C-Space>'] = cmp.mapping.complete {},
            },
            sources = {
                {
                    name = 'lazydev',
                    group_index = 0,
                },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            },

            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = lspkind.cmp_format({
                    mode = 'symbol',
                    maxwidth = {
                        menu = 100,
                        abbr = 100,
                    },
                    ellipsis_char = '...',
                    show_labelDetails = true,
                    before = function (entry, vim_item)
                        vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
                        vim_item.menu = ({
                            nvim_lsp = '[LSP]',
                            luasnip = '[Snippet]',
                            buffer = '[Buffer]',
                            path = '[Path]',
                        })[entry.source.name]
                        return vim_item
                    end
                })
            }
        }
    end,
}
