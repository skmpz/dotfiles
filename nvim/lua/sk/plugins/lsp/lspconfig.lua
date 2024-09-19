return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            opts.buffer = bufnr

            -- show lsp definitions
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

            -- go to declaration
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

            -- show definition, references
            keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

            -- show lsp implementations
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

            -- jump to previous diagnostic in buffer
            keymap.set("n", "<leader>p", vim.diagnostic.goto_prev, opts)

            -- jump to next diagnostic in buffer
            keymap.set("n", "<leader>n", vim.diagnostic.goto_next, opts)

            -- see available code actions, in visual mode will apply to selection
            keymap.set({ "n", "v" }, "<leader>j", vim.lsp.buf.code_action, opts)

            -- rename
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

            -- restart lsp
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

            -- show  diagnostics for file
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

            -- show diagnostics for line
            keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)

            -- format
            keymap.set("n", "<C-f>", vim.lsp.buf.format, opts)

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
        end

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = "•", Warn = "•", Hint = "•", Info = "•" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- configure html server
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure css server
        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure tailwindcss server
        lspconfig["tailwindcss"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure svelte server
        lspconfig["svelte"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)

                vim.api.nvim_create_autocmd("BufWritePost", {
                    pattern = { "*.js", "*.ts" },
                    callback = function(ctx)
                        if client.name == "svelte" then
                            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                        end
                    end,
                })
            end,
        })

        -- configure prisma orm server
        lspconfig["prismals"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure graphql language server
        lspconfig["graphql"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })

        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })

        -- configure python server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configured in rust-tools.lua
        -- configure rust server
        -- lspconfig["rust_analyzer"].setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        -- })

        -- configure cpp server
        lspconfig["clangd"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { -- custom settings for lua
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}
