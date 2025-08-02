return {
    'nvim-telescope/telescope.nvim',
    enabled = false,
    -- "nvim-telescope/telescope-ui-select.nvim",
    -- tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },
        "nvim-telescope/telescope-live-grep-args.nvim",
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        require('telescope').setup {
            defaults = {
                file_ignore_patterns = {
                    "%.git",
                },
                -- vimgrep_arguments = {
                --     "rg",
                --     "--color=never",
                --     "--no-heading",
                --     "--with-filename",
                --     "--line-number",
                --     "--column",
                --     "--smart-case",
                --     "--hidden",
                --     -- "--no-ignore",  -- optional
                -- },
            },
            extensions = {
                fzf = {},
                ["ui-select"] = require("telescope.themes").get_dropdown{},
            },
            pickers = {
                find_files = { theme = "ivy" },
                live_grep =  { theme = "ivy" },
            }
        }

        require('telescope').load_extension('fzf')
        require('telescope').load_extension('live_grep_args')
        require("telescope").load_extension("ui-select")
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf',  function() builtin.find_files({ hidden = true }) end, {})
        vim.keymap.set('n', '<C-g>',       builtin.git_files, {})
        vim.keymap.set('n', '<leader>gk',  builtin.git_bcommits, {})
        vim.keymap.set('n', '<leader>ps',  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
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

        -- Shortcut for searching your todo files
        vim.keymap.set("n", "<C-e>", function()
            require("telescope.builtin").find_files {
                search_dirs = { vim.fn.expand("~/work/todo"), vim.fn.expand("~/personal/todo") },
            }
        end)
    end,
}
