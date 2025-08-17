-- treesitter.lua
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c', 'cpp', 'lua', 'python', 'rust', 'go',
    'javascript', 'json', 'yaml', 'bash', 'cmake',
    'make', 'asm', 'toml'
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
}

