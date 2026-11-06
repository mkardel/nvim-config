# Neovim Cheat Sheet                                                        *keys*

Leader key = <Space>. After pressing <Space>, a menu (which-key) shows your options.
Press <Esc> to stop before the menu fires if you change your mind.

## Survival basics
| key        | what                                        |
|------------|---------------------------------------------|
| i          | insert mode (typing)                        |
| <Esc>      | back to normal mode (also clears highlight) |
| :w / :q / :wq | save / quit / both — or <Space>w <Space>q |
| u / <C-r>  | undo / redo                                 |
| dd / yy / p | delete line / copy line / paste            |
| x          | delete one char                             |
| 5j / 5w / 3fa | count prefix works on movements (5 down, 3 words, find next 'a') |
| w b e 0 $  | word right / left / end / line start / line end |
| gg G / ^   | top / bottom / first non-blank              |
| f a ; ,    | jump to next 'a' / repeat / reverse         |
| / pattern  | search (n next, N previous)                 |
| V / v      | visual lines / visual chars                 |
| ctrl-g / <C-o> <C-i> | where am I / jump back / jump forward |
| zz         | recenter screen                             |

## Files & buffers
| key        | what                                  |
|------------|---------------------------------------|
| <Space>e   | file explorer (neo-tree) toggle       |
| <Space>ff  | find files                            |
| <Space>fg  | grep EVERY file (live, as you type)   |
| <Space>fb  | switch buffers                        |
| <Space>fr  | recently used files                   |
| <Space>fw  | fuzzy search inside current file      |
| <Space>fh  | search :help                          |
| <Space>fT  | list TODO/FIXME comments              |
| <Space>bd  | close current buffer                  |
| <Space>l / <Space>h (with Shift) | next / previous buffer |
| <Space><Space> | switch to the other (alternate) file |
| <Space>i   | popup explaining the error under cursor |

## Code intelligence (needs a language server — auto-installed)
| key        | what                                   |
|------------|----------------------------------------|
| K          | docs for the symbol under cursor        |
| gd         | jump to definition                      |
| gD         | jump to declaration                     |
| gI         | jump to implementation                  |
| gr         | rename symbol everywhere (type new name, <CR>) |
| <Space>ca  | code actions: fix imports, add return type, extract variable... |
| <Space>cf  | format buffer (also automatic on save)  |
| <Space>cs  | symbol outline for current file         |
| <Space>gd  | definitions list (telescope version)    |
| <Space>gR  | all references to the symbol            |
| <Space>gG  | search symbols across the whole project |
| <Space>go  | organize imports (Go)                   |
| [d / ]d    | previous / next error or warning        |
| <Space>ft  | list ALL errors/warnings in project     |
| <C-Space>  | trigger completion manually (<CR> to accept, <Tab> to move) |

## Debugging (DAP) — same keys in C, Go and Python
Flow:  open file -> <Space>db on a line -> <Space>dc -> step with dn/di/dI -> <Space>dt

| key        | what                                          |
|------------|-----------------------------------------------|
| <Space>db  | toggle breakpoint on current line             |
| <Space>d?  | conditional breakpoint (e.g. i == 3)          |
| <Space>dl  | log point (prints without pausing)            |
| <Space>dC  | clear all breakpoints                         |
| <Space>dc  | START DEBUGGING / continue                    |
| <Space>dn  | step OVER the line                            |
| <Space>di  | step INTO the function                        |
| <Space>dI  | step OUT of the function                      |
| <Space>du  | show/hide the debug panels (vars, stack...)   |
| <Space>de  | inspect the variable under cursor             |
| <Space>dv  | open the debug REPL (type expressions!)       |
| <Space>dr  | restart the program                           |
| <Space>dt  | stop the program                              |

Per language:
- Go    : just <Space>db then <Space>dc on a .go file (dlv builds it for you).
- Python: same — runs the current file with debugpy.
- C     : compile first with debug info:  :make  (then <Space>db / <Space>dc;
          the executable next to the .c file is auto-detected).

## Git (gitsigns) — inside a git repo
| key        | what                          |
|------------|-------------------------------|
| ]c / [c    | next / previous changed hunk  |
| <Space>hp  | preview what changed          |
| <Space>hs  | stage hunk   <Space>hu undo stage   <Space>hr reset hunk |
| <Space>hS  | stage whole file  <Space>hR reset file |
| <Space>hb  | blame: who wrote this line    |
| <Space>gs  | git status (telescope)        |
| <Space>gc  | commit log                    |
| <Space>gb  | branches                      |

## Treesitter smart selection & textobjects
| key        | what                                            |
|------------|-------------------------------------------------|
| <Space>n   | select syntax node; press again to grow         |
| <Space>N   | shrink selection back                           |
| dif / daf  | delete function inner / a function              |
| yif / yaf  | yank (copy) inner function / whole function     |
| vic / vac  | visual / change a class                         |
| dia / dia  | inside/around argument                          |
| [f / ]f    | jump to previous / next function                |

## Windows & terminal
| key           | what                                   |
|---------------|----------------------------------------|
| <Space>\|     | vertical split                         |
| <Space>_      | horizontal split                       |
| <Space>-      | close split                            |
| <C-w> h/j/k/l | move to left/down/up/right window      |
| <C-w> - / +   | shrink / grow window height            |
| <C-w> \| / _  | shrink / grow window width             |
| <Space>t      | open terminal inside Neovim            |
| <Esc><Esc>    | leave terminal mode                    |

## One-liners that feel like cheating
- `qa!` quit without saving          - `.` repeat last change
- `ci"`, `ci(`, `vi(`                change/delete/visual INSIDE quotes/parens
- `:s/old/new/gc`                    find & replace in file (confirm each)
- `:10,20s/old/new/g`                same, but only lines 10-20
- `:grep TODO | copen`               grep + open quickfix
- `ga`                             show unicode codepoint of char under cursor
- `:checkhealth`                    doctor for Neovim
- `:Lazy`                           plugin manager (Colorschemes tab to try themes)
- `:Mason`                          manage LSP servers / debuggers

NOTE: icons in the UI need a "Nerd Font" (e.g. JetBrainsMono Nerd Font).
Without one you get boxes — everything else still works.

vim: ft=markdown tw=100
