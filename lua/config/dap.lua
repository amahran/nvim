local dap = require("dap")
local dapui = require("dapui")

-- Configure native gdb adapter
dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

-- gdb's own stdin is the DAP pipe, so a launched program that reads stdin
-- sees EOF immediately. This adapter opens a terminal split and points the
-- inferior's stdin/stdout at its pty instead.
local tty_term = nil
dap.adapters.gdb_tty = function(callback)
    vim.cmd('botright 12split | enew')
    local chan = vim.fn.jobstart({ 'sleep', 'infinity' }, { term = true })
    tty_term = { chan = chan, buf = vim.api.nvim_get_current_buf() }
    local tty = vim.api.nvim_get_chan_info(chan).pty
    vim.cmd('wincmd p')
    callback({
        type = 'executable',
        command = 'gdb',
        args = { '--interpreter=dap', '--eval-command', 'set print pretty on',
                 '--eval-command', 'set inferior-tty ' .. tty },
    })
end
local function close_tty_term()
    if tty_term then
        vim.fn.jobstop(tty_term.chan)
        pcall(vim.api.nvim_buf_delete, tty_term.buf, { force = true })
        tty_term = nil
    end
end
dap.listeners.after.event_terminated.tty_term = close_tty_term
dap.listeners.after.event_exited.tty_term = close_tty_term

dap.configurations.c = {
    {
        name = "Launch (interactive stdin)",
        type = "gdb_tty",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = {},
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = {},
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
        cwd = '${workspaceFolder}',
    },
    {
        name = 'Attach to gdbserver :1234',
        type = 'gdb',
        request = 'attach',
        target = 'localhost:1234',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
    },
}
dap.configurations.cpp = dap.configurations.c

-- dap-ui setup + auto open/close
dapui.setup()
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- Global keymaps
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dr', function() dapui.open() end)
vim.keymap.set('n', '<Leader>du', function() dapui.toggle() end)
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)

-- Activate step keymaps only when a debug session starts
dap.listeners.after.event_process.dapui_config = function()
    vim.keymap.set('n', '<Down>', function() dap.step_over() end)
    vim.keymap.set('n', '<Right>', function() dap.step_into() end)
    vim.keymap.set('n', '<Left>', function() dap.step_out() end)
    vim.keymap.set('n', '<Up>', function() dap.restart_frame() end)
end
