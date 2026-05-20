-- =========================================
-- Plugin declarations via vim.pack
-- =========================================
-- Run :lua vim.pack.update() to update all plugins
-- Run :lua vim.pack.del('plugin-name') to remove a plugin
-- Lockfile: ~/.config/nvim/nvim-pack-lock.json

vim.pack.add({
    -- Colorschemes (only kanagawa is active, others kept for easy switching)
    'https://github.com/rebelot/kanagawa.nvim',
    -- 'https://github.com/vague2k/vague.nvim',
    -- 'https://github.com/folke/tokyonight.nvim',
    -- 'https://github.com/rose-pine/neovim',
    -- 'https://github.com/catppuccin/nvim',
    -- 'https://github.com/navarasu/onedark.nvim',

    -- Completion
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') },
    'https://github.com/rafamadriz/friendly-snippets',

    -- LSP
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/folke/lazydev.nvim',

    -- Treesitter
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    'https://github.com/rush-rs/tree-sitter-asm',

    -- DAP (Debugging)
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/rcarriga/nvim-dap-ui',
    'https://github.com/nvim-neotest/nvim-nio',

    -- Snacks (picker, scope, etc.)
    'https://github.com/folke/snacks.nvim',

    -- Git
    'https://github.com/tpope/vim-fugitive',

    -- Editing
    'https://github.com/tpope/vim-surround',
    'https://github.com/mg979/vim-visual-multi',

    -- Utilities
    'https://github.com/lambdalisue/vim-suda',

    -- Markdown preview (requires deno)
    'https://github.com/toppair/peek.nvim',
})

-- Handle post-install/update hooks
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind

        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then
                vim.cmd.packadd('nvim-treesitter')
            end
            vim.cmd('TSUpdate')
        end

        if name == 'peek.nvim' and (kind == 'install' or kind == 'update') then
            -- peek.nvim needs a build step (deno) on first install and updates
            vim.system({ 'deno', 'task', '--quiet', 'build:fast' }, { cwd = ev.data.path })
        end
    end,
})

-- Keymap for updating plugins
vim.keymap.set('n', '<leader>pu', '<cmd>lua vim.pack.update()<CR>', { desc = 'Update plugins' })
