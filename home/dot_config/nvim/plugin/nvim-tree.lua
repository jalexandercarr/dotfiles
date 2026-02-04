-- Nvim-Tree — File explorer sidebar
-- Plugin: nvim-tree/nvim-tree.lua

-- Disable netrw at the very start (recommended by nvim-tree docs)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local ok, nvimtree = pcall(require, 'nvim-tree')
if not ok then return end

nvimtree.setup()

-- Keybindings
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'Toggle NvimTree' })
vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>', { noremap = true, silent = true, desc = 'Find file in NvimTree' })
