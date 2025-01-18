return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
		 'hrsh7th/cmp-buffer',
		 'hrsh7th/cmp-nvim-lsp',
		 'neovim/nvim-lspconfig',
		 'hrsh7th/cmp-cmdline',
		 'hrsh7th/cmp-path',
         'L3MON4D3/LuaSnip',
         'saadparwaiz1/cmp_luasnip',
         'onsails/lspkind.nvim',
         "rafamadriz/friendly-snippets",
        },
        config = function()
            -- Set up nvim-cmp.
            local cmp = require'cmp'
            local lspkind = require('lspkind')
            local luasnip = require'luasnip'

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- alt-i for jumping to the layed out function arguments by the lsp
                    ['<M-i>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<M-o>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer', keyword_length = 5 },
                    { name = 'path' },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            nvim_lua = "[Lua]",
                            latex_symbols = "[Latex]",
                        })
                    }),
                },
            })

            -- Set configuration for specific filetype.
            -- cmp.setup.filetype('gitcommit', {
            --     sources = cmp.config.sources({
            --         { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            --     }, {
            --         { name = 'buffer' },
            --     })
            -- })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            --[[ cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            }) ]]

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            --[[ cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            }) ]]

            -- Set up lspconfig.
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            require('lspconfig')['clangd'].setup {
                capabilities = capabilities
            }
            require('lspconfig')['cmake'].setup {
                capabilities = capabilities
            }
        end,
    },
}

