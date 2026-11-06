-- ============================================================================
--  Editor options (the "settings" of Neovim)
-- ============================================================================

local opt = vim.opt

-- UI -------------------------------------------------------------------------
opt.number = true              -- show line numbers
opt.relativenumber = true      -- ...relative to cursor (great for counting jumps)
opt.mouse = 'a'                -- mouse works in the terminal (clicking, scroll wheel)
opt.termguicolors = true       -- 24-bit colors
opt.signcolumn = 'yes'         -- always reserve the sign gutter (no text jitter)
opt.laststatus = 3             -- one global statusline at the very bottom
opt.showmode = false           -- lualine shows the mode instead
opt.cmdheight = 0              -- cleaner cmdline (0.10+ hides the extra row)
opt.scrolloff = 8              -- keep 8 lines of context above/below the cursor
opt.sidescrolloff = 8
opt.cursorline = true          -- highlight the current line
opt.shortmess:append 'c'       -- don't spam completion messages
opt.winbar = ''

-- Searching ------------------------------------------------------------------
opt.ignorecase = true          -- search is case-insensitive...
opt.smartcase = true           -- ...unless you type a capital letter
opt.hlsearch = true            -- highlight matches (Esc clears them in this config)
opt.wrapscan = true

-- Editing --------------------------------------------------------------------
opt.expandtab = true           -- tabs become spaces (Go overrides this: gofmt = tabs)
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.breakindent = true
opt.undofile = true            -- real undo history, survives closing files
opt.undolevels = 10000
opt.updatetime = 250           -- snappier signs/diagnostics
opt.timeoutlen = 500           -- wait this long for key sequences (which-key shows them)
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.confirm = true             -- ask to save unsaved changes when closing
opt.splitright = true          -- :vsplit opens to the RIGHT
opt.splitbelow = true          -- :split  opens BELOW
opt.clipboard = 'unnamedplus'  -- y/p integrate with the system clipboard (OSC52)

-- Treesitter diagnostics & LSP UI ---------------------------------------------
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  virtual_text = { spacing = 2 },
}

-- Filetype-specific indent style (matches gofmt / PEP8 / Linux C style)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.bo.expandtab = false   -- gofmt uses real tabs
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
  end,
})
