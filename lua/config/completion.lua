require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        ['<C-k>'] = false, -- keep digraphs working in insert mode
        ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    appearance = {
        nerd_font_variant = 'mono',
    },
    sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            buffer = {
                min_keyword_length = 5,
            },
            snippets = {
                min_keyword_length = 2,
            },
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
            },
        },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
})
