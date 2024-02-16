return {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local api = vim.api
        local metals_config = require("metals").bare_config()

        -- Example of settings
        metals_config.settings = {
            showImplicitArguments = true,
            excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        }

        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap -- for conciseness

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

        -- *READ THIS*
        -- I *highly* recommend setting statusBarProvider to true, however if you do,
        -- you *have* to have a setting to display this in your statusline or else
        -- you'll not see any messages from metals. There is more info in the help
        -- docs about this
        -- metals_config.init_options.statusBarProvider = "on"

        -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- metals_config.on_attach = function(client, bufnr)
        --     require("metals").setup_dap()
        -- end

        -- Autocmd that will actually be in charging of starting the whole thing
        local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
        api.nvim_create_autocmd("FileType", {
            -- NOTE: You may or may not want java included here. You will need it if you
            -- want basic Java support but it may also conflict if you are using
            -- something like nvim-jdtls which also works on a java filetype autocmd.
            pattern = { "scala", "sbt", "java" },
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
        })
    end,
}
