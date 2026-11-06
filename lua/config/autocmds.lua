-- ============================================================================
--  Autocommands — automatic behaviors
-- ============================================================================

-- Flash the yanked text so you SEE what you copied
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = 'elite',
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
})

-- Center the cursor when paging / searching
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Never let :bdelete kill the editor when it was the last buffer
vim.api.nvim_create_autocmd('BufWipeout', {
  desc = 'Keep at least one buffer',
  group = 'elite',
  callback = function()
    if vim.v.exiting ~= vim.NIL then return end
    local cur = vim.api.nvim_get_current_buf()
    for _, b in ipairs(vim.fn.getbufinfo { buflisted = 1 }) do
      if b.bufnr ~= cur then return end -- something else is still listed
    end
    vim.cmd 'enew'
  end,
})

-- Format on save for our three languages (uses the LSP servers)
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Format C/Go/Python on save',
  group = 'elite',
  pattern = { '*.c', '*.h', '*.cpp', '*.py' },
  callback = function()
    pcall(vim.lsp.buf.format, { timeout_ms = 2000 })
  end,
})

-- Go: organize imports, then format, on save
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'gofmt + goimports on save',
  group = 'elite',
  pattern = '*.go',
  callback = function()
    pcall(vim.lsp.buf.code_action, {
      context = { only = { 'source.organizeImports' } },
      apply = true, range = nil,
    })
    pcall(vim.lsp.buf.format, { timeout_ms = 2000 })
  end,
})

-- In :terminal, turn off fancy options and jump to the bottom
vim.api.nvim_create_autocmd('TermOpen', {
  group = 'elite',
  callback = function()
    vim.bo.nolist = true
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd 'startinsert'
  end,
})
