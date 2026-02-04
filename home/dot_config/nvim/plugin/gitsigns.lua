-- Gitsigns — Git change indicators in the sign column
-- Plugin: lewis6991/gitsigns.nvim

local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then return end

gitsigns.setup({
  current_line_blame = true, -- Show git blame info for the current line
})
