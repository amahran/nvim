require('kanagawa').setup({
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
})
require('rose-pine').setup({
    styles = {
        bold = true,
        italic = false,
    },
})

vim.cmd.colorscheme('rose-pine')
