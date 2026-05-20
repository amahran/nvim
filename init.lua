-- Load core settings first (these have no plugin dependencies)
require('elprofessor/options')
require('elprofessor/remap')

-- Install and load all plugins via vim.pack
require('elprofessor/pack')

-- Configure plugins (order matters: colorscheme first, then LSP deps, then the rest)
require('config/colorscheme')
require('config/treesitter')
require('config/lsp')
require('config/completion')
require('config/dap')
require('config/snacks')
require('config/misc')
