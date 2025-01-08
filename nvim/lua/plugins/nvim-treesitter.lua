return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
        ensure_installed = {
            'bash',
            'cmake',
            'cpp',
            'css',
            'dockerfile',
            'gitignore',
            'go',
            'graphql',
            'groovy',
            'html',
            'java',
            'javascript',
            'json',
            'lua',
            'make',
            'markdown',
            'markdown_inline',
            'python',
            'regex',
            'rust',
            'scala',
            'sql',
            'terraform',
            'toml',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
            'yaml',
        },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { 'ruby' } },
    },
}