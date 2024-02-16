return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "windwp/nvim-ts-autotag",
        },
        config = function()
            -- import nvim-treesitter plugin
            local treesitter = require("nvim-treesitter.configs")

            -- configure treesitter
            treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
            },

            -- enable indentation
            indent = { enable = true },

            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },

            -- ensure these language parsers are installed
            ensure_installed = {
                "bash",
                "cpp",
                "css",
                "dockerfile",
                "gitignore",
                "go",
                "graphql",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "prisma",
                "python",
                "query",
                "rust",
                "scala",
                "svelte",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            -- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
        })
    end,
},
}
