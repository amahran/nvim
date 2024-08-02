-- by default the config dir is in the rtp
-- however there is a caveate, nvim when looking for 
-- lua code for plugins, it looks for a dir called `lua`
-- see :h rtp
require('elprofessor/options')
require('elprofessor/remap')
require('elprofessor/lazy')

-- Function to change color scheme when entering and exiting diff mode
local function change_color_scheme()
  if vim.wo.diff then
    vim.cmd('colorscheme tokyonight-moon')
  else
    vim.cmd('colorscheme rose-pine')
  end
end

-- Create an autocommand group for changing color schemes
vim.api.nvim_create_augroup('ChangeColorSchemeOnDiff', { clear = true })
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'diff',
  callback = change_color_scheme,
  group = 'ChangeColorSchemeOnDiff',
})

-- Apply initial color scheme
vim.cmd.colorscheme('rose-pine')

