-- nvim-lspconfig names (see :h lspconfig-all)
local servers = {
    clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--cross-file-rename", "--fallback-style=google" },
        init_options = {
            clangdFileStatus = true,
        },
        settings = {
            ["clangd.filetypes"] = {
                c = { ".h" },
            },
        },
    },
    bitbake_language_server = {
        cmd = { "language-server-bitbake" },
    },
    lua_ls = {},
    dockerls = {},
    pyright = {},
    neocmake = {},
}

-- Mason: install LSP servers and tools
require('mason').setup()

-- mason-lspconfig: auto-install LSP servers
-- (bitbake is not supported by mason-lspconfig, handled separately)
local mason_servers = vim.tbl_keys(servers)
-- remove bitbake from mason list
mason_servers = vim.tbl_filter(function(s) return s ~= 'bitbake_language_server' end, mason_servers)
require('mason-lspconfig').setup({
    ensure_installed = mason_servers,
})

-- mason-tool-installer: tools besides LSPs
require('mason-tool-installer').setup({
    ensure_installed = { 'cmakelang', 'language-server-bitbake', 'black', 'shfmt' },
})

-- lazydev: provides vim API completions for Lua
require('lazydev').setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        "nvim-dap-ui",
    },
})

-- conform: formatting
require('conform').setup({
    formatters_by_ft = {
        cmake = { "cmake_format" },
        python = { "black" },
        sh = { "shfmt" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
})

-- LSP server configuration
for name, server_opts in pairs(servers) do
    server_opts.capabilities = vim.lsp.protocol.make_client_capabilities()
    server_opts.capabilities = vim.tbl_deep_extend(
        'force',
        server_opts.capabilities,
        require('blink.cmp').get_lsp_capabilities()
    )
    vim.lsp.config(name, server_opts)
    vim.lsp.enable(name)
end

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set('n', '<leader>pd', vim.diagnostic.setqflist)

-- LSP keymaps (only after server attaches)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(event)
        vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
            require('conform').format({ async = true })
        end, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
    end,
})
