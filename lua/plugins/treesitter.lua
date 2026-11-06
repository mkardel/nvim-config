-- ============================================================================
--  Treesitter — a real parser for beautiful syntax highlighting, smart
--  selection (press <Space>n repeatedly to grow the selection) and textobjects
--  like `dif` (delete inner function), `yaf` (yank a function), `vac` ...
-- ============================================================================
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'c', 'go', 'python', 'lua', 'vim', 'vimdoc', 'bash', 'regex', 'comment', 'toml' },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<Space>n',      -- normal: start selecting the node
          node_incremental = '<Space>n',    -- visual: grow to parent node
          node_decremental = '<Space>N',    -- visual: shrink back
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- automatically jumps to the next textobject
          keymaps = {
            ['af'] = '@function.outer', ['if'] = '@function.inner',
            ['ac'] = '@class.outer',    ['ic'] = '@class.inner',
            ['aa'] = '@parameter.outer', ['ia'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']p'] = '@parameter.inner',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[p'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}
