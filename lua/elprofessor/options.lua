local options = {
    number = true,
    relativenumber = true,

    -- splitbelow = true, -- hor splits appear below
    -- splitright = true, -- vertical splits appear on the right

    wrap = false,

    expandtab = true,
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,

    smartindent = true,

    -- sync with system clipboard
    -- TODO: Probably not a very good idea to mix things up
    -- clipboard = 'unnamedplus',

    scrolloff = 8,

    virtualedit = 'block',

    -- split the window down for substitute commands
    -- helpful when the file is so long and I want to see all
    -- the changes at once
    inccommand = 'split',

    -- ignore caseing when dealing with commands so writing
    -- somthing like :netr and then <tab> will give us the help menu
    -- ignorecase = true,

    termguicolors = true,
    guicursor = '',

    -- undo forever
    swapfile = false,
    backup = false,
    undodir = os.getenv("HOME") .. "/.vim/undodir", -- save undofile(s) in this path
    undofile = true,                                -- keep undo file across vim sessions

    signcolumn = "yes",                             -- this is a column in the left side to show signs like a breakpoint for example
    updatetime = 50,                                -- write the swap file to disk 50 msec after the last keystroke in insert mode -> helpful for recovery
    -- not sure if this of any help bacause the swapfile is disabled
    -- however undotree might be used for this purpose instead of swap

    colorcolumn = "80",

    -- (de)activate by :set (no)list to show white space characters
    listchars = "tab:→ ,trail:·,space:·,eol:↲",

    -- Enable project-specific config files
    exrc = true,
    secure = true,

    -- floating windows boarder
    winborder = 'rounded',
}


for key, value in pairs(options) do
    vim.opt[key] = value
end
vim.opt.isfname:append("@-@") -- add @ as a valid character if it does appear in a file name

-- global option affects all buffers, windows and tabs
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
