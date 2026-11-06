-- ============================================================================
--  Autocompletion: nvim-cmp + LuaSnip snippets
--  <C-Space> triggers completion, <Tab>/<S-Tab> navigate, <CR> accepts.
-- ============================================================================
return {

  { 'hrsh7th/nvim-cmp', priority = 1000, dependencies = {
      'hrsh7th/cmp-nvim-lsp',      -- completions from the language servers
      'hrsh7th/cmp-buffer',        -- words from the current buffer
      'hrsh7th/cmp-path',          -- file paths
      'L3MON4D3/LuaSnip',          -- snippet engine
      'saadparwaiz1/cmp_luasnip',       -- snippet completions
      'rafamadriz/friendly-snippets', -- a big collection of ready-made snippets
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load() -- load friendly-snippets

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-Space>'] = cmp.mapping.complete(),          -- force menu
          ['<C-e>'] = cmp.mapping.abort(),                 -- dismiss menu
          ['<CR>'] = cmp.mapping.confirm { select = false }, -- Enter accepts (if something is typed)
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({ nvim_lsp = '[LSP]', luasnip = '[snip]', buffer = '[buf]', path = '[path]' })[entry.source.name]
            return vim_item
          end,
        },
      }
    end,
  },

  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true }, -- auto-close (), "", ''
}
