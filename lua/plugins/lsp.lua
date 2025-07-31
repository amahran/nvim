local servers = {
    clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--cross-file-rename" },
        init_options = {
            clangdFileStatus = true,
            fallbackFlags = { "-std=c11" },
        },
        settings = {
            ["clangd.filetypes"] = {
                c = { ".h" },
            },
        },
    },
    bitbake_language_server = {
        cmd = { "language-server-bitbake" }, -- somebody screw up the command name upstream
    },
    lua_ls = {},
    dockerls = {},
    pyright = {},
    neocmake = {},
}

return {
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            'mason-org/mason.nvim',
            opts = {},
        },
        opts = function(_, opts)
            servers.bitbake_language_server = nil -- that is not supported in mason-lspconfig
            local ensure_installed = vim.tbl_keys(servers)
            opts.ensure_installed = ensure_installed
        end,
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
            -- tools besides LSPs
            -- bitbake is here because it's not supported by mason-lspconfig
            ensure_installed = { 'cmakelang', 'language-server-bitbake' },
        },

    },
    { -- provides vim API
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                cmake = { "cmake_format" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        }
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- servers names are the nvim-lspconfig names
            for name, server_opts in pairs(servers) do
                server_opts.capabilities = vim.lsp.protocol.make_client_capabilities()
                vim.lsp.config(name, server_opts)
                vim.lsp.enable(name)
            end

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
            vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(event)
                    -- Enable completion triggered by <c-x><c-o>
                    -- TODO this might not be really needed with nvim.cmp installed
                    vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = event.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        require('conform').format({ async = true })
                    end, opts)
                end,
            })
        end,
    },
    -- {
    --     'p00f/clangd_extensions.nvim',
    --     config = function()
    --         require("clangd_extensions").setup {
    --             server = {
    --                 cmd = { "clangd", "--background-index", "--clang-tidy", "--cross-file-rename" },
    --                 filetypes = { "c", "cpp", "objc", "objcpp" },
    --             },
    --             extensions = {
    --                 autoSetHints = true,
    --             },
    --         }
    --     end,
    -- }
}
