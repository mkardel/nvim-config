-- ============================================================================
--  LSP (language intelligence) + Mason (installs/maintains the servers)
--
--  Servers auto-installed by Mason:
--    clangd  -> C        pyright -> Python type checking
--    gopls   -> Go       ruff    -> Python lint/format/organize-imports
--    lua_ls  -> Neovim config files
-- ============================================================================
return {

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      { 'williamboman/mason-lspconfig.nvim' },
      'folke/neodev.nvim', -- Lua API hints when editing this config
    },
    config = function()
      -- Completion capabilities for every server
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      vim.lsp.config('clangd', {
        settings = { clangd = { inlayHints = { parameterNames = { enabled = 'literals' } } } },
      })

      vim.lsp.config('gopls', {
        settings = { gopls = {
          goimports = true,
          staticcheck = true,
          analyses = { useunusedparams = true, shadow = true },
        } },
      })

      vim.lsp.config('ruff', {
        -- Ruff is the fastest Python linter + formatter (written in Rust)
        settings = { ruff = { organizeImportsInApplyMode = 'always' } },
      })

      vim.lsp.config('lua_ls', {
        settings = { Lua = { diagnostics = { globals = { 'vim' } }, workspace = { checkThirdParty = false } } },
      })

      require('mason-lspconfig').setup {
        -- NOTE: these are Mason PACKAGE names (the Lua one differs from its lsp name).
        -- gopls is intentionally NOT here: it's installed via `go install` (see below).
        ensure_installed = { 'clangd', 'pyright', 'ruff', 'lua-language-server' },
      }

      -- Enable the LSP CONFIGS (nvim-lspconfig provides sensible defaults for each)
      vim.lsp.enable({ 'clangd', 'gopls', 'pyright', 'ruff', 'lua_ls' })
    end,
  },

  -- Keymaps that exist only when a language server is attached to a buffer.
  -- (K = hover docs is native; gd/gD/K work everywhere.)
  {
    'neovim/nvim-lspconfig', -- (same spec; lazy merges — this just adds the autocmd)
    init = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local bufnr = ev.buf
          local map = function(keys, fn, desc)
            vim.keymap.set('n', keys, fn, { buffer = bufnr, desc = desc })
          end
          map('gd', vim.lsp.buf.definition, 'Go to definition')
          map('gD', vim.lsp.buf.declaration, 'Go to declaration')
          map('gI', vim.lsp.buf.implementation, 'Go to implementation')
          map('gr', vim.lsp.buf.rename, 'Rename symbol')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action (quick fix)')
          map('<leader>cf', function() vim.lsp.buf.format { async = true } end, 'Format buffer')
          map('<leader>cs', function() vim.lsp.buf.document_symbol() end, 'Symbols in this file')
        end,
      })
    end,
  },
}
