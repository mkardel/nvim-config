-- ============================================================================
--  Colorscheme. Load first (priority) so everything else inherits its palette.
--  Try others anytime:  :Lazy  ->  Colorschemes  tab
-- ============================================================================
return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme 'tokyonight-night' end,
  },
}
