return {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,   -- This plugin is already lazy
    config = function()
        local mason_registry = require('mason-registry')
        local codelldb = mason_registry.get_package("codelldb")
        local extension_path = codelldb:get_install_path() .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lib/liblldb.so"
        local cfg = require('rustaceanvim.config')

        vim.g.rustaceanvim = {
            dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            }
        }

        local keymap = vim.keymap -- for conciseness
        keymap.set("n", "<leader>rt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger step into" })
        keymap.set("n", "<leader>rr", "<cmd>lua vim.cmd('RustLsp runnables')<CR>", { desc = "Debugger step into" })
        keymap.set("n", "<leader>rd", "<cmd>lua vim.cmd('RustLsp debuggables')<CR>", { desc = "Debugger step into" })

    end,
}
