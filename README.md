# Elite Neovim setup — C, Go & Python IDE with real debugging

A portable Neovim config that turns nvim into a full IDE: IntelliSense,
breakpoint debugging, fuzzy search, git signs, auto-format on save — for **C**,
**Python** and **Go**. Works on **Linux and macOS**.

- New machine? See **[SETUP.md](SETUP.md)** (one command: `./install.sh`).
- Inside nvim, press **`F1`** anytime to open the full cheat sheet
  (**[KEYS.md](KEYS.md)**).

---

## The one concept you must learn: the Leader key

All the custom shortcuts are prefixed with the **Leader key**, which in this
config is the **Space bar**. So when docs say `<leader>e`, you press `Space`
then `e`. That's it. After pressing Space, a menu (which-key) pops up showing
your options — you don't need to memorize everything.

**You now type `nvim` (not `vim`).** Everything else about Vim works exactly as
you know it.

---

## Daily driving (the 80% you'll use)

| Press | What happens |
|---|---|
| `Space e` | File explorer sidebar (`Space e` again to close) |
| `Space f f` | **Find files** — type a few letters, Enter to open |
| `Space f g` | **Grep** — search text in every file (project-wide) |
| `Space f r` | Recently used files |
| `Space w` | Save |
| `Space q` | Close window |
| `gd` | **Go to definition** of the word under your cursor |
| `C-o` | Jump back where you came from |
| `K` | Hover docs for the function under your cursor |
| `gr` | Rename the symbol everywhere in your project |
| `Space c a` | Auto-fix / code actions (format also runs on save) |
| `Space -` / `Space _` | Split window horizontally / vertically |
| `C-h j k l` | Move between windows |
| `Space t` | Open a terminal inside nvim (`Esc Esc` to leave it) |

A **completion popup** appears while typing — `Tab`/`Shift-Tab` to choose,
`Enter` to accept.

**Errors light up as you type** (clangd, pyright and gopls are doing this).
Press `K` or `Space i` to read them; `[d` and `]d` jump between errors.

---

## Debugging like a pro

The debugging dance is **identical in C, Python and Go**:

```
Space d b   -> set breakpoint on current line
Space d c   -> start debugging / continue to next breakpoint
Space d n   -> next line (step over)
Space d i   -> step INTO the function
Space d v   -> debug REPL (type expressions!)
Space d t   -> stop debugging
```

When stopped, variable values appear **inline in the code**, plus panels for
locals, stack, breakpoints and a console.

Extras: `Space d ?` sets a **conditional breakpoint** (e.g. `i == 5`),
`Space d l` a **log point**, and selecting lines then pressing `Space d e`
**evaluates any expression** mid-debug. `Space d u` shows/hides the panels.

Per-language specifics:

- **Go**    — `Space d b` then `Space d c` on a .go file (dlv builds it for you).
- **Python** — same; runs the current file with debugpy.
- **C**     — compile with debug info first: `:make` (the Makefile must use
  `-g -O0`). The executable next to the .c file is auto-detected.

### Practice: planted bugs

`~/code-samples/` ships three small programs, each with **one deliberate bug**,
plus README walkthroughs:

1. `cd ~/code-samples/c && nvim main.c` — string reversal drops the last
   character. Breakpoint inside the `reverse()` loop, `Space d c`, watch the
   loop counter (`:make` rebuilds).
2. `cd ~/code-samples/python && nvim main.py` — `moving_average()` divides by
   the wrong count. Breakpoint inside the function and step through.
3. `cd ~/code-samples/go && nvim main.go` — `average()` divides by
   `len(xs)-1`. Breakpoint on the `return` and watch the divisor.

Catch all three and you know how to debug anything.

---

## Portability (Linux **and** macOS)

This directory **is a git repository**. To move the whole setup to a new
machine:

```bash
# On a new machine (Debian/Ubuntu with apt, or macOS with Homebrew):
git clone <your-remote> ~/.config/nvim
cd ~/.config/nvim
./install.sh        # installs nvim, compilers, Go, gopls, dlv, debugpy...
nvim                # first launch auto-installs all plugins + language servers
```

Push this repo to GitHub to carry it everywhere:

```bash
git remote add origin <your-repo> && git push -u origin main
```

Useful commands inside nvim: `:Lazy` (plugin manager), `:Mason` (browse/update
language servers and debuggers), `:checkhealth` (self-diagnosis).

Full details, per-OS notes (CodeLLDB used for C on both OSes — no gdb needed
on macOS) and Nerd Font hints are in **[SETUP.md](SETUP.md)**.

---

## What's inside

| Path | Contents |
|---|---|
| `init.lua` | entry point; bootstraps lazy.nvim |
| `lua/config/` | options, keymaps, autocmds |
| `lua/plugins/` | one file per feature: lsp, dap, telescope, treesitter, cmp, editor, theme |
| `install.sh` | cross-platform bootstrap (apt / Homebrew), idempotent |
| `lazy-lock.json` | pinned plugin versions (reproducibility) |
| `KEYS.md` | the cheat sheet (`F1` opens it inside nvim) |
| `SETUP.md` | machine setup & per-OS notes |

Two small notes:

1. **Nerd Font** — UI icons need one (e.g. JetBrainsMono Nerd Font) selected in
   your *terminal's* font settings. Without it you see odd boxes; nothing
   breaks. Hints in SETUP.md.
2. **Go tools** live in `~/go/bin` — the config adds it to PATH itself, but
   your *shell* needs it too for `go build` etc. (install.sh appends it to
   `.bashrc`/`.zshrc` if missing).
