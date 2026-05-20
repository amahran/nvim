require('snacks').setup({
    picker = {
        enabled = true,
        ui_select = true,
        layout = {
            preset = "ivy",
            cycle = true,
        },
        matcher = {
            cwd_bonus = true,
            frecency = true,
            history_bonus = true,
        },
        files = {
            cmd = 'fd',
        },
        grep = {
            cmd = 'rg',
        },
    },
    scope = { enabled = true },
})

-- Picker keymaps
vim.keymap.set('n', '<leader>fn', function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
vim.keymap.set('n', '<C-g>', function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set('n', '<leader>sm', function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set('n', '<M-e>', function()
    Snacks.picker.files({ dirs = { vim.fn.expand("~/work/todo"), vim.fn.expand("~/personal/todo/") } })
end, { desc = "fzf todo files" })
