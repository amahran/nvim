return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        'rush-rs/tree-sitter-asm', -- for asm parser as claimed TODO needs testing
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    main = "nvim-treesitter.configs", -- tell lazy nvim how to call setup, default is 'nvim-treesitter'
    opts = function()
        local core = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
        local parsers = { 'cpp', 'asm', 'cmake', 'make', 'meson', 'ninja' }
        for _, lang in ipairs(core) do
            table.insert(parsers, lang)
        end

        return {
            ensure_installed = parsers,
            sync_install = false,
            auto_install = true,
            ignore_install = { "" },
            additional_vim_regex_highlighting = false,
            modules = {}, -- Additional modules configuration can go here
            highlight = {
                enable = true,
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            incremental_selection = {
                enable = true,
                -- those are global keymaps
                keymaps = {
                    init_selection = "<leader>ss", -- This also can be started by entering visual line mode
                    node_incremental = "<leader>si",
                    scope_incremental = "<leader>sc",
                    node_decremental = "<leader>sd",
                },
            },
            indent = {
                enable = true
            },
            -- from nvim-treesitter-textobjects
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    -- Those are working in operator pending mode
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    include_surrounding_whitespace = true,
                },
            },
        }
    end,
}
