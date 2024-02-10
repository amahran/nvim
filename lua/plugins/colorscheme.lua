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
            vim.cmd.colorscheme('rose-pine')
        end,
    },
}
