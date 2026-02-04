-- Lualine — Statusline with default sections
-- Plugin: nvim-lualine/lualine.nvim

local ok, lualine = pcall(require, 'lualine')
if not ok then return end

lualine.setup({
  extensions = { 'nvim-tree' }, -- Integrate with nvim-tree file explorer
})
