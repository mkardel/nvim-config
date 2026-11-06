-- ============================================================================
--  DEBUGGING with the Debug Adapter Protocol (DAP)
--    C        -> codelldb   (installed by Mason)
--    Go       -> delve/dlv  (installed via `go install`, on PATH)
--    Python   -> debugpy    (installed via pip)
--
--  Flow:  <leader>db  set breakpoint  ->  <leader>dc  start/continue
--         <leader>dn  step over   <leader>di into   <leader>dI out
--         <leader>du  toggle the debug panels       <leader>dt  terminate
-- ============================================================================
return {

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
      'leoluz/nvim-dap-go',
    },
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
      { '<leader>d?', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Conditional breakpoint' },
      { '<leader>dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point: ') end, desc = 'Log point (no pause)' },
      { '<leader>dC', function() require('dap').clear_breakpoints() end, desc = 'Clear breakpoints' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'Continue / start debugging' },
      { '<leader>dn', function() require('dap').step_over() end, desc = 'Step over' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step into function' },
      { '<leader>dI', function() require('dap').step_out() end, desc = 'Step out of function' },
      { '<leader>dr', function() require('dap').restart() end, desc = 'Restart session' },
      { '<leader>dt', function() require('dap').terminate() require('dapui').close() end, desc = 'Terminate session' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle debug UI' },
      { '<leader>dv', function() require('dap').repl.open() end, desc = 'Open REPL' },
      { '<leader>de', function() require('dapui').eval() end, mode = { 'n', 'v' }, desc = 'Inspect value under cursor' },
      { '<leader>ds', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', desc = 'All workspace errors' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- UI panels: scopes / breakpoints / stacks / watches + terminal.
      -- v4 defaults: panels on the right/bottom + integrated terminal.
      dapui.setup()
      require('nvim-dap-virtual-text').setup {} -- show variable values inline

      -- Auto-open the UI when a session starts, auto-close when it ends
      dap.listeners.after.event_initialized['auto'] = function() dapui.open() end
      dap.listeners.before.event_terminated['auto'] = function() dapui.close() end
      dap.listeners.before.event_detached['auto'] = function() dapui.close() end

      -- ---- C / C++ : codelldb (path installed by Mason) ---------------------
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }
      local function c_program()
        -- Smart default: ./<name> next to the .c file if it is executable,
        -- else the first executable file in that directory, otherwise prompt.
        -- Compile first with `:make` or !gcc -g ...
        local dir = vim.fn.expand('%:p:h')
        local stem = dir .. '/' .. vim.fn.expand('%:t:r')
        if vim.fn.executable(stem) == 1 then return stem end
        local skip = { ['.c'] = 1, ['.h'] = 1, ['.py'] = 1, ['.go'] = 1,
                       ['.lua'] = 1, ['.sh'] = 1, ['.o'] = 1, ['.so'] = 1 }
        for _, f in ipairs(vim.fn.glob(dir .. '/*', false, true)) do
          local ext = f:match('%.%w+$')
          if vim.fn.executable(f) == 1 and vim.fn.isdirectory(f) == 0
             and not (ext and skip[ext]) then
            return f
          end
        end
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end
      dap.configurations.c = { {
        name = 'Debug current file (compile with -g first)',
        type = 'codelldb', request = 'launch',
        program = c_program, cwd = '${workspaceFolder}', stopOnEntry = false,
      } }
      dap.configurations.cpp = dap.configurations.c

      -- ---- Python : debugpy -------------------------------------------------
      dap.adapters.python = {
        type = 'executable',
        command = 'python3',
        args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations.python = { {
        type = 'python', request = 'launch', name = 'Run current file',
        program = '${file}',          -- the open .py file
        pythonOptions = { '-u' },     -- unbuffered output
        justMyCode = false,           -- also step into library code if needed
        console = 'integratedTerminal', -- use Neovim's terminal panel
      } }

      -- ---- Go : delve (registered automatically by nvim-dap-go) --------------
      require('dap-go').setup() -- finds dlv on PATH; uses a free port automatically
    end,
  },
}
