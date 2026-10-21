-- vim-surround: works out of the box, no setup needed

-- vim-visual-multi
vim.g.VM_maps = {
    ["Find Under"] = "<A-n>",
}

-- undotree
vim.cmd.packadd('nvim.undotree')
vim.keymap.set('n', '<leader>u', '<cmd>Undotree<cr>')

-- vim-fugitive
vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>')

-- vim-suda: works out of the box
