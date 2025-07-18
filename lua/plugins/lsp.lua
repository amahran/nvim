return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'williamboman/mason.nvim',
                config = true,
            },
            { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'folke/neodev.nvim' }, -- for bringing up the vim api
            {
                'stevearc/conform.nvim',
                config = function()
                    require('conform').setup({
                        formatters_by_ft = {
                            cmake = { "cmake_format" },
                        },
                        default_format_opts = {
                            lsp_format = "fallback",
                        },
                    })
                end,
            }

        },
        config = function()
            require('mason-tool-installer').setup {
                -- cmakelang provide cmake-format and other tools for cmake lsp
                ensure_installed = { 'cmakelang' },
            }
            require('mason-lspconfig').setup {
                ensure_installed = { 'clangd', 'lua_ls', 'dockerls', 'cmake', 'pyright' }
            }
            require('neodev').setup()
            -- Setup language servers.
            local lspconfig = require('lspconfig')
            lspconfig.clangd.setup {
                cmd = { "clangd", "--background-index", "--clang-tidy", "--cross-file-rename" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = require('lspconfig').util.root_pattern("compile_commands.json", ".git", "tags", "Makefile", "CMakeLists.txt"),
                capabilities = vim.lsp.protocol.make_client_capabilities(),
                init_options = {
                    clangdFileStatus = true,
                    fallbackFlags = { "-std=c11" },
                },
                settings = {
                    -- Specify that .h files should be treated as C files
                    ["clangd.filetypes"] = {
                        c = { ".h" }
                    }
                }
            }
            lspconfig.lua_ls.setup {}
            lspconfig.dockerls.setup {}
            lspconfig.pyright.setup {}
            lspconfig.bitbake_ls.setup {}
            lspconfig.cmake.setup {}

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', function()
                vim.diagnostic.jump({ count = -1, float = true })
            end)

            vim.keymap.set('n', ']d', function()
                vim.diagnostic.jump({ count = 1, float = true })
            end)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    --print(string.format('event fired: %s', vim.inspect(ev)))
                    -- Enable completion triggered by <c-x><c-o>
                    -- TODO this might not be really needed with nvim.cmp installed
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
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
    {
        'p00f/clangd_extensions.nvim',
        config = function()
            require("clangd_extensions").setup {
                server = {
                    cmd = { "clangd", "--background-index", "--clang-tidy", "--cross-file-rename" },
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                },
                extensions = {
                    autoSetHints = true,
                    inlay_hints = {
                        highlight = "Comment",
                    },
                },
            }
        end,
    }
}
