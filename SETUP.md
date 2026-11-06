# Setting up this config anywhere (Linux & macOS)

This config is portable by design: it's plain Lua + lazy.nvim, and every
language tool is installed by a package manager (apt / Homebrew / go / pip /
Mason), never hardcoded to one machine.

## One-time machine setup

```bash
# 1. Get the config onto the machine (clone your repo, or copy the directory)
git clone <your-repo-url> ~/.config/nvim      # or: cp -r old-machine:~/.config/nvim ~/.config/

# 2. Run the installer — detects apt vs Homebrew automatically, idempotent
~/.config/nvim/install.sh

# 3. Open nvim once and let it fetch the rest (plugins + LSPs + debugger adapter)
nvim        # first launch: lazy.nvim installs ~30 plugins, Mason installs
            # clangd, pyright, ruff, lua-language-server, codelldb automatically
```

That's it. To check what nvim found, run inside nvim:

| Command      | What it shows                                        |
|--------------|------------------------------------------------------|
| `:Lazy`      | plugin installer status (press `I` to install/sync)  |
| `:Mason`     | LSP servers / debuggers installed per-machine        |
| `:checkhealth nvim` | sanity check for clipboard, providers, etc.     |

## What install.sh does

- **Linux (Debian/Ubuntu via apt):** git, curl, unzip, make, ripgrep, fd,
  clang/clang-format/clangd, gdb, python3 + pip/venv/dev headers, build-essential.
  Installs Neovim from the official GitHub release if missing (apt's is often old),
  and Go from apt or the official tarball.
- **macOS (Homebrew):** neovim, ripgrep, fd, clang-format, go, python3 +
  Xcode command line tools. clangd and codelldb come from Mason automatically.
- Everywhere: `go install` for **gopls** (Go language server) and **dlv**
  (Delve debugger), `pip install --user` for **debugpy**, then
  `nvim --headless '+Lazy! sync'` to pre-install plugins.

## Per-OS notes

- **macOS:** you need the Xcode Command Line Tools for a C compiler
  (`xcode-select --install`); clang-format and clangd come from
  brew/Mason. GDB is NOT used on mac — C/C++ debugging uses **codelldb**
  everywhere, so it works the same on both OSes.
- **Linux:** Ubuntu's `fd` is packaged as `fdfind`; install.sh symlinks it.
- **Nerd Font (both):** install a Nerd Font (e.g. JetBrainsMono Nerd Font)
  in your *terminal* so statusline/icons render. On mac: `brew install --cask font-jetbrains-mono-nerd-font`
  then pick it in Terminal/iTerm2 settings. On Linux: drop the .ttf files into
  `~/.local/share/fonts` and run `fc-cache -f`, then pick it in your terminal.
- **Terminal inside screen/tmux:** all fine; nvim works everywhere.

## Syncing to another machine

This directory is a git repository. After editing the config on one machine:

```bash
cd ~/.config/nvim && git add -A && git commit -m "tweak" && git push
```

On the other machine: `cd ~/.config/nvim && git pull` — plugins/tooling update
themselves on next launch (`:Lazy sync`, or automatic on start).

## Sample projects

`~/code-samples/{c,python,go}` contain small buggy programs for practicing the
debugger. Each has a README walkthrough; the C sample also ships
`compile_flags.txt` so clangd configures itself with zero setup.
