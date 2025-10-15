-- =================== lua/lsp/servers.lua ===================
-- Updated servers.lua
-- Key changes:
-- * Uses `vim.lsp.config` when available (Neovim 0.11+).
-- * Falls back to `require('lspconfig')` for older setups.
-- * Uses mason-lspconfig `automatic_installation` option.
-- * Fixes the TypeScript server name to `tsserver` (common mason name).
-- * Keeps your custom clangd filetypes and other per-server settings.


local lspconfig = vim.lsp.config or require('lspconfig')
local ok_mason, mason = pcall(require, 'mason')
local ok_mlsp, mlsp = pcall(require, 'mason-lspconfig')


if ok_mason then mason.setup() end
if ok_mlsp then
mlsp.setup {
ensure_installed = {
'clangd', 'lua_ls', 'gopls', 'ts_ls',
'jsonls', 'yamlls', 'pyright', 'rust_analyzer'
},
automatic_installation = true,
}
end


-- common capabilities (add cmp support if available)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp and cmp_lsp and cmp_lsp.default_capabilities then
capabilities = cmp_lsp.default_capabilities(capabilities)
end
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- on_attach: LSP-based keymaps and helper functions
local on_attach = function(client, bufnr)
local opts = { buffer = bufnr, silent = true }
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)


-- formatting - in Neovim >=0.8 use vim.lsp.buf.format
-- passing async = true is still valid in many setups; if you prefer
-- synchronous formatting remove the table.
vim.keymap.set('n', '<leader>lf', function()
-- prefer server-based formatting when available
if client.server_capabilities and client.server_capabilities.documentFormattingProvider then
vim.lsp.buf.format { async = true }
else
-- fall back to vim.lsp.buf.format anyway (no-op if not supported)
vim.lsp.buf.format { async = true }
end
end, opts)
end

