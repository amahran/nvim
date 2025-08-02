-- Plugin setup using lazy.nvim
return {
    {
        "vague2k/vague.nvim",
        priority = 1000,
        opts = {
            italic = false,
        },
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            commentStyle = { italic = false },
            keywordStyle = { italic = false },
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                comments = { italic = false },
                keywords = { italic = false },
                functions = { bold = false },
                variables = {},
                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = "dark", -- style for sidebars, see below
                floats = "dark",   -- style for floating windows
            },
            dim_inactive = true,
        },
    },
    {
        'rose-pine/neovim',
        name = "rose-pine",
        opts = {
            variant = 'main',
            dark_variant = 'main',
            -- so that I don't lose my eyes in a single coding session
            dim_inactive_windows = true,
            styles = {
                italic = false,
                transparency = false,
            },
        }
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                -- telescope = true,
                treesitter = true,
                which_key = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
            },
        },
    },
}
