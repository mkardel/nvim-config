-- ============================================================================
--  Keymap reference lives here. Full cheat sheet: ~/.config/nvim/KEYS.md
--  Legend: <Space> = leader.  Press <Space> then wait to see the menu popup.
-- ============================================================================

local map = vim.keymap.set

-- General --------------------------------------------------------------------
map('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save (write)' })
map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit window' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })
map('n', '<F1>', '<cmd>edit ~/.config/nvim/KEYS.md<cr>', { desc = 'Open cheat sheet' })
map('n', '<leader>v', '<cmd>e ~/.config/nvim/<cr>', { desc = 'Edit my nvim config' })

-- Yank/paste with the system clipboard (works over SSH too)
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })

-- Windows (splits) ------------------------------------------------------------
-- Move:  <C-w>h/j/k/l     Resize:  <C-w>- / <C-w>+ / <C-w>| / <C-w>_
map('n', '<leader>-', '<cmd>close<cr>', { desc = 'Close split' })
map('n', '<leader>|', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
map('n', '<leader>_', '<cmd>split<cr>', { desc = 'Horizontal split' })

-- Terminal ---------------------------------------------------------------------
map('n', '<leader>t', function()
  vim.cmd 'belowright 12split | terminal'
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<StartInsert>', true, false, true), 'n', false)
end, { desc = 'Open terminal split' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode (Esc Esc)' })

-- Buffers ----------------------------------------------------------------------
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<S-h>', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-- Diagnostics (problems reported by the language servers) -----------------------
map('n', '[d', '<cmd>diagnostic_jump_prev<cr>', { desc = 'Prev diagnostic' })
map('n', ']d', '<cmd>diagnostic_jump_next<cr>', { desc = 'Next diagnostic' })
map('n', '<leader>i', vim.diagnostic.open_float, { desc = 'Show error under cursor' })

-- Quickfix / loclist navigation
map('n', '[q', '<cmd>cprev<cr>zz', { desc = 'Prev quickfix item' })
map('n', ']q', '<cmd>cnext<cr>zz', { desc = 'Next quickfix item' })

-- Indent stays selected after >> or << in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Jump to line number quickly
map('n', '<leader><leader>', '<C-^>', { desc = 'Switch to alternate file' })
