return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
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
                cmd = 'fd'
            },
            grep = {
                cmd = 'rg'
            },
        },
        -- This thing cause rendering problems when opening files
        -- quickfile = { enabled = true },
        scope = { enabled = true },
    },
    keys = {
        -- find
        { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,                                             desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end,                                                                               desc = "Find Files" },
        { "<leader>fb", function() Snacks.picker.buffers() end,                                                                             desc = "Find Files" },
        { "<C-g>",      function() Snacks.picker.git_files() end,                                                                           desc = "Find Git Files" },
        -- Grep
        { "<leader>sg", function() Snacks.picker.grep() end,                                                                                desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end,                                                                           desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        -- { "<leader>pd",  function() Snacks.picker.diagnostics() end,                                                                         desc = "Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end,                                                                                desc = "Help Pages" },
        { "<leader>sr", function() Snacks.picker.resume() end,                                                                              desc = "Resume" },
        { "<leader>sm", function() Snacks.picker.man() end,                                                                                 desc = "Man Pages" },
        { "<M-e>",      function() Snacks.picker.files({ dirs = { vim.fn.expand("~/work/todo"), vim.fn.expand("~/personal/todo/") } }) end, desc = "fzf todo files" },
        --         vim.keymap.set('n', '<leader>pWs', function()
        --             local word = vim.fn.expand("<cWORD>")
        --             builtin.grep_string({ search = word })
        --         end)
    },
}
