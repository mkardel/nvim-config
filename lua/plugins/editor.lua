-- ============================================================================
--  UI polish: file tree, statusline, git signs, keymap help, indentation guides
-- ============================================================================
return {

  -- The file explorer sidebar --------------------------------------------------
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'File explorer' },
      { '<leader>E', '<cmd>Neotree reveal toggle<cr>', desc = 'Explorer (reveal current file)' },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = 'open_current',
        use_libuv_file_watcher = true,
      },
      window = { position = 'left', width = 30, mappings = { ['<space>'] = 'none' } },
    },
  },

  -- Keymap menu: press <Space> and wait — a menu of available keys pops up -----
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function() vim.o.timeout = true vim.o.timeoutlen = 400 end,
    config = function()
      local wk = require 'which-key'
      wk.setup {}
      wk.add {
        { '<leader>b', group = 'Buffer' },
        { '<leader>c', group = 'Code (LSP)' },
        { '<leader>d', group = 'Debug (DAP)' },
        { '<leader>e', group = 'Explorer' },
        { '<leader>f', group = 'Find' },
        { '<leader>g', group = 'Git / Code' },
        { '<leader>h', group = 'Git hunk' },
        { '<leader>t', group = 'Terminal' },
        { '[', group = 'Previous' },
        { ']', group = 'Next' },
      }
    end,
  },

  -- Statusline -----------------------------------------------------------------
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = { theme = 'tokyonight', globalstatus = true },
        sections = { lualine_x = { 'diagnostics', 'encoding', 'filetype' } },
      }
    end,
  },

  -- Git signs in the gutter ------------------------------------------------------
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, keys, fn, desc)
          vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc })
        end
        map('n', ']c', gs.next_hunk, 'Next git hunk')
        map('n', '[c', gs.prev_hunk, 'Prev git hunk')
        map({ 'n', 'v' }, '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map({ 'n', 'v' }, '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('n', '<leader>hS', gs.stage_buffer, 'Stage whole file')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset whole file')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Blame this line')
        map('n', '<leader>hd', gs.diffthis, 'Diff this file')
      end,
    },
  },

  -- Indentation guides -------------------------------------------------------------
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', event = 'VeryLazy',
    opts = { exclude = { filetypes = { 'neo-tree', 'terminal', 'telescope' } } } },

  -- Highlight TODO/FIXME/HACK + telescope search (<leader>ft already diagnostics)
  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { { '<leader>fT', '<cmd>TodoQuickFix<cr>', desc = 'TODO/FIXME list' } },
    opts = {} },
}
