-- LSP — Language server protocol with auto-installed servers via Mason
-- Plugin: neovim/nvim-lspconfig, williamboman/mason.nvim, williamboman/mason-lspconfig.nvim
-- Uses vim.lsp.config / vim.lsp.enable (Neovim 0.11+)
--
-- Configured servers:
--   gopls    (Go)         pyright  (Python)      ts_ls    (JS/TS)
--   bashls   (Bash)       lua_ls   (Lua/Neovim)  jsonls   (JSON)
--   yamlls   (YAML)       dockerls (Dockerfiles)

-- Mason manages installing LSP server binaries
local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then return end

mason.setup()

-- Ensures listed servers are installed on first launch
require('mason-lspconfig').setup({
  ensure_installed = {
    'gopls',       -- Go
    'pyright',     -- Python
    'ts_ls',       -- JavaScript / TypeScript
    'bashls',      -- Bash
    'lua_ls',      -- Lua
    'jsonls',      -- JSON
    'yamlls',      -- YAML
    'dockerls',    -- Dockerfiles
  },
})

-- LSP keybindings — applied when any server attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.buf }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)            -- Go to definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)           -- Go to declaration
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)        -- Go to implementation
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)            -- List references
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                  -- Hover documentation

    -- Actions
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)        -- Rename symbol
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)   -- Code actions
    vim.keymap.set('n', '<leader>lf', function()                       -- Format buffer
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- Diagnostics
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)          -- Previous diagnostic
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)          -- Next diagnostic
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts) -- Show diagnostic float
  end,
})

-- Advertise nvim-cmp completion capabilities to every LSP server
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Lua LS needs extra settings for Neovim config editing
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },                        -- Recognise the `vim` global
      runtime = { version = 'LuaJIT' },                             -- Neovim's embedded Lua runtime
      workspace = { library = vim.api.nvim_get_runtime_file('', true) }, -- Neovim runtime files
    },
  },
})

-- Enable all configured servers
vim.lsp.enable({
  'gopls',       -- Go
  'pyright',     -- Python
  'ts_ls',       -- JavaScript / TypeScript
  'bashls',      -- Bash
  'lua_ls',      -- Lua
  'jsonls',      -- JSON
  'yamlls',      -- YAML
  'dockerls',    -- Dockerfiles
})
