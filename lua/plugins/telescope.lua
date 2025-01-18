return {
    'nvim-telescope/telescope.nvim',
    -- tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            'nvim-telescope/telescope-fzf-native.nvim',

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = 'make',

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    config = function()
        pcall(require('telescope').load_extension, 'fzf') -- load fzf
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf',  builtin.find_files, {})
        vim.keymap.set('n', '<C-g>',       builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps',  builtin.live_grep, {})
        vim.keymap.set('n', '<leader>pb',  builtin.buffers, {})
        -- search for the word under the cursor
        vim.keymap.set('n', '<leader>pws', builtin.grep_string, {})
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {}) -- This requires built in LSP

        vim.keymap.set('n', '<leader>vk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>ts', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>of', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>bs', builtin.current_buffer_fuzzy_find)

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>ns', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })
    end,
}
