-- Autocompletion — Tab-driven completion with LSP, buffer, and path sources
-- Plugin: hrsh7th/nvim-cmp, hrsh7th/cmp-nvim-lsp, hrsh7th/cmp-buffer, hrsh7th/cmp-path

local ok, cmp = pcall(require, 'cmp')
if not ok then return end

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),        -- Next completion item
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),      -- Previous completion item
    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
    ['<C-Space>'] = cmp.mapping.complete(),             -- Trigger completion manually
    ['<C-e>'] = cmp.mapping.abort(),                    -- Close completion menu
  }),
  -- Completion sources in priority order
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP completions (primary)
    { name = 'buffer' },   -- Words from current buffer
    { name = 'path' },     -- File system paths
  }),
})
