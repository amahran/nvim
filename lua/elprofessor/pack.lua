-- setup lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then -- if the lazypath doesn't exist on the system
    vim.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end

-- say opening a cpp file, nvim goes through
-- the runtime path and asks everyone whether for
-- example they have syntax highlighting for cpp
--
-- same as vim.opt.rtp.prepend(vim.opt.rtp, lazypath)
-- prepend: add to the beginning of the list, other option is append
vim.opt.rtp:prepend(lazypath)

local opts = {
    change_detection = {
        notify = false,
    }
}
-- require looks into the rtp will find lazy.nvim
-- inside it, there is a lua dir
-- inside it there is a lazy dir
-- and if there is an init.lua there, it's gonna
-- run this file
require('lazy').setup('plugins', opts)
