-- ============================================================================
--  ELITE NEOVIM CONFIG — C / Python / Go (LSP + debugging + fuzzy finding)
--  Leader key is <Space>.  Cheat sheet: ~/.config/nvim/KEYS.md  (or press <F1>)
-- ============================================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make Go tools findable (dlv debugger, gopls) even when launched from a GUI
vim.env.PATH = table.concat({
  vim.fn.expand('$HOME/go/bin'),
  '/usr/local/go/bin',
  vim.env.PATH,
}, ':')

-- ---------------------------------------------------------------------------
-- Bootstrap lazy.nvim (the plugin manager) — this just git-clones it on first run
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins live in lua/plugins/*.lua, options/keymaps in lua/config/*.lua
require('lazy').setup('plugins', {
  change_detection = { notify = false },
  rocks = { enabled = false }, -- no luarocks needed
})
