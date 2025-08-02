require('elprofessor/options')
require('elprofessor/remap')
require('elprofessor/lazy')

vim.cmd.colorscheme('kanagawa')

-- vim.api.nvim_create_autocmd("TextYankPost", {
--   callback = function()
--     vim.highlight.on_yank { higroup = "Visual", timeout = 50 }
--   end,
-- })

