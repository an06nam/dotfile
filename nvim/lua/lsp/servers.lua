-- lsp/servers.lua
local lspconfig = require('lspconfig')
local mason = require('mason')
local mlsp = require('mason-lspconfig')

-- Setup mason & install typical servers
mason.setup()
mlsp.setup {
  ensure_installed = {
    "clangd", "lua_ls", "gopls", "ts_ls",
    "jsonls", "yamlls", "pyright", "rust_analyzer"
  },
  automatic_enable = true,
}

-- common configuration
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Attach function with LSP-based keymaps and formatting
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
  vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)
end

-- clangd with .ld and asm support
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--compile-commands-dir=./build" },
  filetypes = { "c", "cpp", "objc", "objcpp", "ld", "asm" },
}

-- Lua lsp
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

-- ts/JS
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- cmake
lspconfig.cmake.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    buildDirectory = "build",
  },
}

-- JSON, YAML, Python, Rust, Go all default
for _, server in ipairs { "jsonls", "yamlls", "pyright", "rust_analyzer", "gopls" } do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
