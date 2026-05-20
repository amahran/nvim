return {
    { 'tpope/vim-surround' },
    {
        'mg979/vim-visual-multi',
        init = function()
            -- Define custom mappings with Alt
            vim.g.VM_maps = {
                ["Find Under"] = "<A-n>",         -- select word under cursor
            }
        end,
    },
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = true,
    },
    {
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>')
        end,
    },
    { "lambdalisue/vim-suda" },
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                filetype = { 'markdown' },
            })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
}
