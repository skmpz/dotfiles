return {
    'mfussenegger/nvim-dap',
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        local dap = require('dap')
        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                command = '/home/sk/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
                args = { "--port", "${port}" }
            }
        }

        local keymap = vim.keymap -- for conciseness
        keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
        keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
        keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
        keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
        keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
            { desc = "Debugger toggle breakpoint" })
        keymap.set("n", "<leader>dd", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
            { desc = "Debugger set conditional breakpoint" })
        keymap.set("n", "<leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
        keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })
    end

}
