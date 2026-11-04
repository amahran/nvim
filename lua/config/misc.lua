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

vim.keymap.set('n', '<leader>dw', function()
  if vim.o.diffopt:find('iwhiteall') then
    vim.opt.diffopt:remove({ 'iwhiteall', 'iblank' })
  else
    vim.opt.diffopt:append({ 'iwhiteall', 'iblank' })
  end
  vim.cmd('diffupdate')
  print('diffopt: ' .. vim.o.diffopt)
end, { desc = 'Toggle ignore-whitespace in diff' })
