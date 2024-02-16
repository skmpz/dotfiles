return {
    "simrat39/rust-tools.nvim",
    dependencies = {
        "neovim/nvim-lspconfig"
    },

    config = function()
        local rt = require("rust-tools")

        rt.setup({
            server = {
                on_attach = function(_, bufnr)
                    local opts = { noremap = true, silent = true }
                    local keymap = vim.keymap -- for conciseness
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

                    -- doc
                    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
                end,

                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy",
                        },
                        diagnostics = {
                            enable = true,
                            disabled = { "unresolved-proc-macro" },
                            enableExperimental = true,
                        },
                        inlay_hints = {
                            auto = true,
                            only_current_line = false,
                            show_parameter_hints = true,
                            parameter_hints_prefix = "<- ",
                            other_hints_prefix = "=> ",
                            max_len_align = false,
                            x_len_align_padding = 1,
                            right_align = false,
                            right_align_padding = 7,
                            highlight = "Comment",
                        }
                    },
                },
            }
        })
    end,
}
