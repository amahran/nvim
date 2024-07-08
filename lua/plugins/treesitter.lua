return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'rush-rs/tree-sitter-asm', -- for asm parser as claimed TODO needs testing
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
        -- A list of parser names, or 'all' (the five listed parsers should always be installed)
        local core = { 'c', 'lua', 'vim', 'vimdoc', 'query' }
        local parsers = { 'cpp', 'asm', 'cmake', 'make', 'meson', 'ninja' }
        for _, lang in ipairs(core) do
            table.insert(parsers, lang)
        end

        require('nvim-treesitter.configs').setup({
            ensure_installed = parsers,
            sync_install = false, -- Install languages synchronously (only applied to `ensure_installed`)
            ignore_install = { "" }, -- List of parsers to ignore installing
            modules = {}, -- Additional modules configuration can go here

            -- this will install the required parsers automatically
            -- anyway if a file has been opened which didn't have a parser installed
            auto_install = true,

            highlight = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                -- those are global keymaps
                keymaps = {
                    -- set to `false` to disable one of the mappings
                    init_selection = "<leader>ss", -- This also can be started by entering visual line mode
                    node_incremental = "<leader>si",
                    scope_incremental = "<leader>sc",
                    node_decremental = "<leader>sd",
                },
            },
            -- from nvim-treesitter-textobjects
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    -- Those are working in operator pending mode
                    keymaps = {
                        -- check those on the github repo for supported capture groups per language
                        -- or open it with `:TSEditQuery textobjects
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        -- You can optionally set descriptions to the mappings (used in the desc parameter of
                        -- nvim_buf_set_keymap) which plugins like which-key display
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        -- You can also use captures from other query groups like `locals.scm`
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = true,
                },
            },
        })
    end,
}
