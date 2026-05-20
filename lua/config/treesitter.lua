-- nvim-treesitter main branch: no more require('nvim-treesitter.configs')
-- The plugin manages parsers/queries; we enable features via Neovim APIs.

local ts = require('nvim-treesitter')

-- Minimal setup (uses default install_dir)
ts.setup({})

-- Install parsers (only installs missing ones, safe to call every startup)
local parsers = {
    -- core
    "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
    -- project-specific
    "cpp", "asm", "cmake", "make", "meson", "ninja",
}

local installed = require('nvim-treesitter.config').get_installed()
local to_install = vim.iter(parsers)
    :filter(function(p) return not vim.tbl_contains(installed, p) end)
    :totable()

if #to_install > 0 then
    ts.install(to_install)
end

-- Enable treesitter highlighting + indentation via FileType autocmd
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
            return -- skip large files
        end
        -- Enable treesitter highlighting (pcall in case no parser exists)
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- nvim-treesitter-textobjects (also needs the main branch)
require('nvim-treesitter-textobjects').setup({
    select = {
        lookahead = true,
        selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
        },
        include_surrounding_whitespace = true,
    },
})

-- Textobject keymaps
local ts_select = require('nvim-treesitter-textobjects.select')
vim.keymap.set({ 'x', 'o' }, 'af', function() ts_select.select_textobject('@function.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'if', function() ts_select.select_textobject('@function.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ac', function() ts_select.select_textobject('@class.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ic', function() ts_select.select_textobject('@class.inner', 'textobjects') end)
