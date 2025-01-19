return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'williamboman/mason.nvim',
                config = true,
            },
            {
                'williamboman/mason-lspconfig.nvim',
                config = function()
                    require('mason-lspconfig').setup {
                        -- ensure_installed = { 'clangd', 'lua_ls'  },
                        -- this will install whatever install with lspconfig.{lsp} automatically
                        -- TODO: There is a circular dependency between that and configuring the servers
                        automatic_installation = true,
                    }
                end,
            },
            {
                'folke/neodev.nvim', -- for bringing up the vim api
            },
        },
        config = function()
            require('mason-lspconfig').setup {
                ensure_installed = { 'clangd', 'lua_ls', 'dockerls', 'cmake' },
                -- this will install whatever install with lspconfig.{lsp} automatically
                -- TODO: There is a circular dependency between that and configuring the servers
                automatic_installation = true,
            }
            require('neodev').setup()
            -- Setup language servers.
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup {}
            lspconfig.clangd.setup {
                cmd = { "clangd", "--background-index", "--clang-tidy", "--cross-file-rename" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = require('lspconfig').util.root_pattern("compile_commands.json", ".git", "tags", "Makefile", "CMakeLists.txt"),
                capabilities = vim.lsp.protocol.make_client_capabilities(),
                init_options = {
                    clangdFileStatus = true,
                    fallbackFlags = { "-std=c17" },
                },
                on_attach = function(client, bufnr)
                    -- Enable more capabilities or commands here if necessary
                end,
                settings = {
                    -- Specify that .h files should be treated as C files
                    ["clangd.filetypes"] = {
                        c = { ".h" }
                    }
                }
            }

            lspconfig.dockerls.setup {}
            lspconfig.pyright.setup {}
            lspconfig.bitbake_ls.setup {}

            -- CMake Language Server
            lspconfig.cmake.setup {
                cmd = { "cmake-language-server" },
                filetypes = { "cmake" },
                root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
                init_options = {
                    buildDirectory = "build",
                },
            }

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
                        vim.lsp.buf.format { async = true }
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
