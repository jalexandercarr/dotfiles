-- Which-Key — Displays available keybindings in a popup
-- Plugin: folke/which-key.nvim

local ok, wk = pcall(require, 'which-key')
if not ok then return end

wk.setup()

-- Register key groups so which-key shows descriptive labels
wk.add({
  { '<leader>f', group = 'File' },
  { '<leader>b', group = 'Buffer' },
  { '<leader>w', group = 'Window' },
  { '<leader>l', group = 'LSP' },
})
