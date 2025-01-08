return {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local api = vim.api
        local metals_config = require("metals").bare_config()

        metals_config.settings = {
            showImplicitArguments = true,
            excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        }

        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap

        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        keymap.set("n", "<leader>p", vim.diagnostic.goto_prev, opts)
        keymap.set("n", "<leader>n", vim.diagnostic.goto_next, opts)
        keymap.set({ "n", "v" }, "<leader>j", vim.lsp.buf.code_action, opts)
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)
        keymap.set("n", "<C-f>", vim.lsp.buf.format, opts)
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

        local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
        api.nvim_create_autocmd("FileType", {
            pattern = { "scala", "sbt", "java" },
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
        })
    end,
}
