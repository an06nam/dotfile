-- =================== lua/lsp/servers.lua ===================

local ok_mason, mason = pcall(require, 'mason')
local ok_mlsp, mlsp = pcall(require, 'mason-lspconfig')

if not ok_mason or not ok_mlsp then
  vim.notify("Mason not available", vim.log.levels.WARN)
  return
end

mason.setup()
mlsp.setup {
  ensure_installed = {
    'clangd', 'lua_ls', 'gopls', 'ts_ls',
    'jsonls', 'yamlls', 'pyright', 'rust_analyzer'
  },
  automatic_installation = true,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end
capabilities.textDocument.completion.completionItem.snippetSupport = true

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
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>lf', function()
    if client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format { async = true }
    end
  end, opts)
end

-- pick the correct API depending on Neovim version
vim.lsp.config('clangd', {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { 'clangd', '--background-index', '--compile-commands-dir=../build' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'ld', 'asm' },
})

vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('ts_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('cmake', {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = { buildDirectory = 'build' },
})

for _, server in ipairs { 'jsonls', 'yamlls', 'pyright', 'rust_analyzer', 'gopls' } do
  vim.lsp.config('[server]', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

