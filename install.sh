#!/usr/bin/env bash
# ============================================================================
#  One-shot portable installer for the elite nvim config.
#  Supports: Linux (Debian/Ubuntu via apt) and macOS (Homebrew).
#  Idempotent: safe to run repeatedly; skips whatever is already present.
#
#  Usage:  ./install.sh          (from anywhere; paths are absolute)
# ============================================================================
set -uo pipefail

ok()   { printf '  \033[32mok\033[0m      %s\n' "$1"; }
skip() { printf '  \033[90malready\033[0m   %s\n' "$1"; }
run()  { printf '  ..        %s\n' "$1"; }

OS="$(uname -s)"

# ---------------------------------------------------------------------------
# 1. System packages
# ---------------------------------------------------------------------------
if command -v apt-get >/dev/null 2>&1; then
  SUDO=''; [ "$(id -u)" -ne 0 ] && SUDO='sudo'
  NEED=()
  for pkg in git curl unzip make ripgrep fd-find clang clang-format clangd gdb \
             python3 python3-pip python3-venv python3-dev build-essential; do
    dpkg -l "$pkg" 2>/dev/null | grep -q '^ii' || NEED+=("$pkg")
  done
  if [ ${#NEED[@]} -gt 0 ]; then
    run "apt-get install ${NEED[*]}"
    $SUDO apt-get update -qq && $SUDO apt-get install -y -qq "${NEED[@]}"
  else
    skip "all apt packages"
  fi
  # Ubuntu names it fdfind; nvim/telescope expect `fd`
  [ ! "$(command -v fd 2>/dev/null)" ] && [ "$(command -v fdfind 2>/dev/null)" ] \
    && $SUDO ln -s "$(command -v fdfind)" /usr/local/bin/fd
elif [ "$OS" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS. Install it from https://brew.sh and re-run." >&2
    exit 1
  fi
  for formula in git neovim ripgrep fd clang-format go python3; do
    if brew list "$formula" >/dev/null 2>&1; then skip "brew $formula"; else run "brew install $formula"; brew install "$formula"; fi
  done
  # Command-line developer tools provide clang/gcc:
  xcode-select -p >/dev/null 2>&1 || { run "xcode-select --install"; xcode-select --install; }
else
  echo "Unsupported platform: $OS (Linux w/ apt or macOS expected)" >&2
fi

# ---------------------------------------------------------------------------
# 2. Neovim >= 0.11 (apt's is usually too old, so use the GitHub release)
# ---------------------------------------------------------------------------
need_nvim=1
if command -v nvim >/dev/null 2>&1; then
  ver=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  major=${ver%%.*}; minor=${ver#*.}; minor=${minor%%.*}
  if [ "${major:-0}" -gt 0 ] || { [ "${major:-0}" -eq 0 ] && [ "${minor:-0}" -ge 11 ]; }; then
    need_nvim=0; skip "neovim $ver"
  fi
fi
if [ "$need_nvim" -eq 1 ] && ! command -v brew >/dev/null 2>&1; then
  # Linux: official tarball -> /opt/nvim
  asset=nvim-linux-x86_64.tar.gz
  url="https://github.com/neovim/neovim/releases/latest/download/$asset"
  run "downloading neovim"
  curl -fsSL "$url" -o /tmp/nvim.tar.gz
  sudo rm -rf /opt/nvim && sudo tar -C /opt -xzf /tmp/nvim.tar.gz
  sudo ln -sf "/opt/$(tar -tzf /tmp/nvim.tar.gz | head -1 | cut -d/ -f1)/bin/nvim" /usr/local/bin/nvim
  ok "neovim $(nvim --version | head -1)"
elif [ "$need_nvim" -eq 1 ] && command -v brew >/dev/null 2>&1; then
  brew install neovim 2>/dev/null || true; ok "neovim via brew"
fi

# ---------------------------------------------------------------------------
# 3. Go toolchain (gopls + dlv are `go install`-able; Go itself via tarball/apt)
# ---------------------------------------------------------------------------
if ! command -v go >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    run "apt-get install golang-go" && sudo apt-get install -y -qq golang-go
  fi
  if ! command -v go >/dev/null 2>&1; then
    run "downloading go (official tarball)"
    curl -fsSL "https://go.dev/dl/go1.23.4.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
      && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  fi
fi
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin:$(brew --prefix go 2>/dev/null)/bin"
if command -v go >/dev/null 2>&1; then
  command -v gopls >/dev/null 2>&1 || { run "go install gopls"; go install golang.org/x/tools/gopls@latest; }
  command -v dlv   >/dev/null 2>&1 || { run "go install dlv";   go install github.com/go-delve/delve/cmd/dlv@latest; }
  ok "gopls + dlv"
  # make sure Go is on PATH in future shells
  rc=$HOME/.bashrc; [ "$OS" = "Darwin" ] && rc=$HOME/.zshrc
  grep -q '/usr/local/go/bin' "$rc" 2>/dev/null \
    || { printf '\nexport PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"\n' >> "$rc"; ok "PATH updated in $rc"; }
fi

# ---------------------------------------------------------------------------
# 4. Python debugger (debugpy)
# ---------------------------------------------------------------------------
python3 -c 'import debugpy' 2>/dev/null && skip "debugpy" || {
  run "pip install debugpy"
  pip3 install --user debugpy 2>/dev/null \
    || pip3 install --user --break-system-packages debugpy \
    || python3 -m pip install --user --break-system-packages debugpy
}

# ---------------------------------------------------------------------------
# 5. Neovim plugins (lazy.nvim auto-bootstraps on first launch) + Mason tools
# ---------------------------------------------------------------------------
run "syncing nvim plugins (lazy.nvim)"
nvim --headless '+Lazy! sync' +qa >/dev/null 2>&1
ok "plugins synced  (clangd/pyright/ruff/codelldb auto-install on first real launch)"

echo
echo "Done. Open nvim on any C/Go/Python file; press <F1> inside nvim for the cheat sheet."
