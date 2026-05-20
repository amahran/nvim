return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"
    },
    config = function()
        -- Configs are copied from https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#c-c-rust-via-gdb
        local dap = require("dap")
        -- Configure native gdb
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
        }
        dap.configurations.c = {
            {
                name = "Launch",
                type = "gdb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                args = {}, -- provide arguments if needed
                cwd = "${workspaceFolder}",
                stopAtBeginningOfMainSubprogram = false,
            },
            {
                name = "Select and attach to process",
                type = "gdb",
                request = "attach",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                pid = function()
                    local name = vim.fn.input('Executable name (filter): ')
                    return require("dap.utils").pick_process({ filter = name })
                end,
                cwd = '${workspaceFolder}'
            },
            {
                name = 'Attach to gdbserver :1234',
                type = 'gdb',
                request = 'attach',
                target = 'localhost:1234',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}'
            }
        }
        dap.configurations.cpp = dap.configurations.c

        -- recommended by nvim-dap-ui, see github
        require("lazydev").setup({
            library = { "nvim-dap-ui" },
        })
        -- copied from nvim-dap-ui github
        local dapui = require("dapui")
        require("dapui").setup()
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
        -- global keymaps
        vim.keymap.set('n', '<F5>', function() dap.continue() end)
        vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
        vim.keymap.set('n', '<Leader>dr', function() dapui.open() end)
        vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
        -- activate only when a debug process started
        dap.listeners.after.event_process.dapui_config = function()
            vim.keymap.set('n', '<Down>', function() dap.step_over() end)
            vim.keymap.set('n', '<Right>', function() dap.step_into() end)
            vim.keymap.set('n', '<Left>', function() dap.step_out() end)
            vim.keymap.set('n', '<Up>', function() dap.restart_frame() end)
        end
    end,
}
