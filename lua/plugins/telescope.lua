-- ============================================================================
--  Telescope — the fuzzy finder. Fast because it uses ripgrep + fzf algorithm.
-- ============================================================================
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = {
    { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find files' },
    { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Grep in all files' },
    { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Switch buffer' },
    { '<leader>fr', function() require('telescope.builtin').oldfiles() end, desc = 'Recent files' },
    { '<leader>fw', function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Search inside buffer' },
    { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Search help' },
    { '<leader>ft', function() require('telescope.builtin').diagnostics() end, desc = 'All errors/warnings' },
    { '<leader>gs', function() require('telescope.builtin').git_status() end, desc = 'Git status' },
    { '<leader>gc', function() require('telescope.builtin').git_commits() end, desc = 'Git log' },
    { '<leader>gb', function() require('telescope.builtin').git_branches() end, desc = 'Git branches' },
    -- LSP finders (the pro version of Ctrl-F)
    { '<leader>gd', function() require('telescope.builtin').lsp_definitions() end, desc = 'Definitions (telescope)' },
    { '<leader>gR', function() require('telescope.builtin').lsp_references() end, desc = 'References (telescope)' },
    { '<leader>gI', function() require('telescope.builtin').lsp_implementations() end, desc = 'Implementations (telescope)' },
    { '<leader>gS', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'File symbols' },
    { '<leader>gG', function() require('telescope.builtin').lsp_workspace_symbols() end, desc = 'Workspace symbols' },
    { '<leader>go', function() vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true }) end, desc = 'Organize imports (Go)' },
  },
  config = function()
    local telescope = require 'telescope'
    telescope.setup {
      defaults = {
        file_ignore_patterns = { '^.git/', 'node_modules/', 'dist/', 'build/', 'vendor/' },
        path_display = { 'truncate' },
        mappings = { n = { ['<Esc>'] = require('telescope.actions').close } },
      },
      pickers = { find_files = { previewer = false } }, -- snappy, no previews
    }
    pcall(telescope.load_extension, 'fzf')
  end,
}
