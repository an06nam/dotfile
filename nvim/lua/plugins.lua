-- plugins.lua (packer.nvim example)
local packer = require('packer')
packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use ({
    "L3MON4D3/LuaSnip",
    tag = "v2.*",
    run = "make install_jsregexp"
  })
  use { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' }
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  -- optional: completion support
  use 'hrsh7th/nvim-cmp'             -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'         -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'           -- Buffer completions
  use 'hrsh7th/cmp-path'             -- Path completions
  use 'saadparwaiz1/cmp_luasnip'     -- LuaSnip source for nvim-cmp
  use 'rafamadriz/friendly-snippets' -- Predefined snippets
end)

