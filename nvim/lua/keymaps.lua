-- keymaps.lua
local opts = { noremap = true, silent = true }

-- Clipboard mappings
vim.keymap.set('n', '<leader>y', '"+yy', opts)
vim.keymap.set('v', '<leader>y', '"+y', opts)
vim.keymap.set('n', '<leader>p', '"+p', opts)
vim.keymap.set('v', '<leader>p', '"+p', opts)

