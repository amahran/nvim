-- Plugin setup using lazy.nvim
return {
    {
        'rebelot/kanagawa.nvim',
        -- this a callback function that will be only excuted by lazy after lazy 
        -- has downloaded the plugin and the plugin is ready to go
        -- so that we avoid async execution problems of the configurations
        -- e.g. lazy is downloading yet the plugin and meanwhile, the command for setting
        -- up the colorscheme will be executed and cause a failure in this case
        config = function()
            require('kanagawa').setup({
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            require('tokyonight').setup({
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
                    floats = "dark", -- style for floating windows
                },
                dim_inactive = true,
            })
        end,
    },
    {
        'rose-pine/neovim',
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                -- so that I don't lose my eyes in a single coding session
                dim_inactive_windows = true,
                styles = {
                    italic = false,
                    transparency = true,
                },
            })
            -- NOTE: setting the colorscheme has to come after configuring it
            -- vim.cmd for anything you run with :
            -- vim.cmd.colorscheme('rose-pine')
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "soft", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = true,
            })
            -- vim.cmd("colorscheme gruvbox")
        end,
    },
}

