#!/usr/bin/env bash
# =============================================================================
#  setup_mac.sh — Personal macOS Bootstrap
#  Run: chmod +x setup_mac.sh && ./setup_mac.sh
# =============================================================================

# Continuing on errors — each command handles its own failures

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log()     { echo -e "${GREEN}[✔]${RESET} $1"; }
info()    { echo -e "${CYAN}[→]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $1"; }
section() { echo -e "\n${BOLD}${CYAN}━━━ $1 ━━━${RESET}\n"; }
fail()    { echo -e "${RED}[✘]${RESET} $1"; exit 1; }

# ══════════════════════════════════════════════════════════════════════════════
#  0 — GREETING
# ══════════════════════════════════════════════════════════════════════════════
clear
echo -e "${BOLD}${CYAN}"
echo "  ███╗   ███╗  █████╗   ██████╗  ██████╗  ███████╗     ██████╗   ██╗ ██████╗ "
echo "  ████╗ ████║ ██╔══██╗ ██╔════╝ ██╔═══██╗ ██╔════╝     ╚════██╗ ███║ ╚════██╗"
echo "  ██╔████╔██║ ███████║ ██║      ██║   ██║ ███████╗      █████╔╝ ╚██║  █████╔╝"
echo "  ██║╚██╔╝██║ ██╔══██║ ██║      ██║   ██║ ╚════██║      ╚═══██╗  ██║  ╚═══██╗"
echo "  ██║ ╚═╝ ██║ ██║  ██║ ╚██████╗ ╚██████╔╝ ███████║     ██████╔╝  ██║ ██████╔╝"
echo "  ╚═╝     ╚═╝ ╚═╝  ╚═╝  ╚═════╝  ╚═════╝  ╚══════╝     ╚═════╝   ╚═╝ ╚═════╝ "
echo -e "${RESET}"
echo -e "${CYAN}  Personal macOS Setup Script${RESET}"
echo -e "  Started at: $(date '+%Y-%m-%d %H:%M:%S')\n"
echo -e "  This script will:"
echo "    • Install Homebrew"
echo "    • Install iTerm2 + Oh My Zsh + zsh313 theme"
echo "    • Install Brave, Rectangle, Stats, ProtonVPN"
echo "    • Apply macOS personalizations"
echo "    • Run security checks + install open-source security tools"
echo ""
read -rp "  Press ENTER to start, or Ctrl+C to cancel... "

# ══════════════════════════════════════════════════════════════════════════════
#  1 — XCODE COMMAND LINE TOOLS
# ══════════════════════════════════════════════════════════════════════════════
section "Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools…"
  xcode-select --install
  echo "  → A dialog appeared. Install the tools, then press ENTER here."
  read -rp ""
  log "Xcode CLT installed."
else
  log "Xcode CLT already installed. Skipping."
fi

# ══════════════════════════════════════════════════════════════════════════════
#  2 — HOMEBREW
# ══════════════════════════════════════════════════════════════════════════════
section "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for Apple Silicon & Intel
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  log "Homebrew installed."
else
  log "Homebrew already installed. Updating…"
  brew update
fi

# ══════════════════════════════════════════════════════════════════════════════
#  3 — iTerm2
# ══════════════════════════════════════════════════════════════════════════════
section "iTerm2"
if ! brew list --cask iterm2 &>/dev/null; then
  info "Installing iTerm2…"
  brew install --cask iterm2
  log "iTerm2 installed."
else
  log "iTerm2 already installed. Skipping."
fi

# ══════════════════════════════════════════════════════════════════════════════
#  4 — Oh My Zsh
# ══════════════════════════════════════════════════════════════════════════════
section "Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh…"
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log "Oh My Zsh installed."
else
  log "Oh My Zsh already installed. Skipping."
fi

# ── Useful Oh My Zsh plugins ──────────────────────────────────────────────────
info "Installing zsh plugins: zsh-autosuggestions & zsh-syntax-highlighting…"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Enable plugins in .zshrc
sed -i '' 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' \
  "$HOME/.zshrc" 2>/dev/null || true

log "Plugins configured."

# ══════════════════════════════════════════════════════════════════════════════
#  5 — Powerlevel10k Theme
# ══════════════════════════════════════════════════════════════════════════════
section "Powerlevel10k Theme"
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
P10K_DIR="$THEME_DIR/powerlevel10k"

mkdir -p "$THEME_DIR"

if [[ ! -d "$P10K_DIR" ]]; then
  info "Cloning Powerlevel10k…"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  log "Powerlevel10k installed."
else
  log "Powerlevel10k already present. Skipping."
fi

# Set the theme in .zshrc
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc" 2>/dev/null || true
log "ZSH_THEME set to powerlevel10k in ~/.zshrc"

# ══════════════════════════════════════════════════════════════════════════════
#  6 — APPS
# ══════════════════════════════════════════════════════════════════════════════
section "Apps (Casks)"

install_cask() {
  local cask="$1"
  if ! brew list --cask "$cask" &>/dev/null; then
    info "Installing $cask…"
    brew install --cask "$cask" && log "$cask installed."
  else
    log "$cask already installed. Skipping."
  fi
}

install_cask brave-browser
install_cask rectangle
install_cask stats
install_cask protonvpn
install_cask proton-drive
install_cask vlc
install_cask visual-studio-code

# ── DisplayLink Manager (manual — not on Homebrew due to Gatekeeper signing) ──
section "DisplayLink Manager"
if [[ ! -d "/Applications/DisplayLink Manager.app" ]]; then
  warn "DisplayLink Manager must be installed manually (Synaptics removed it from Homebrew)."
  echo ""
  echo "  Opening the download page now in your browser…"
  echo "  Steps:"
  echo "    1. Download the latest .pkg from the page that just opened"
  echo "    2. Open the downloaded .pkg and follow the installer"
  echo "    3. Go to System Settings → Privacy & Security and allow the extension"
  echo ""
  open "https://www.synaptics.com/products/displaylink-graphics/downloads/macos"
  read -rp "  Press ENTER once you have finished the DisplayLink installation… "
  log "DisplayLink — continuing."
else
  log "DisplayLink Manager already installed. Skipping."
fi

# ── Set Brave as default browser ─────────────────────────────────────────────
section "Default Browser → Brave"
if ! brew list defaultbrowser &>/dev/null; then
  info "Installing 'defaultbrowser' CLI tool…"
  brew install defaultbrowser
fi

if command -v defaultbrowser &>/dev/null; then
  info "Setting Brave as default browser…"
  # The bundle ID key for Brave in defaultbrowser is 'brave'
  if defaultbrowser brave 2>/dev/null; then
    log "Brave set as default browser."
  else
    warn "Could not set Brave automatically. Do it manually: Brave → Settings → Make default browser."
  fi
else
  warn "defaultbrowser tool not found — set Brave manually via its Settings page."
fi

# ══════════════════════════════════════════════════════════════════════════════
#  7 — DEVELOPER / CLI TOOLS  (edit freely)
# ══════════════════════════════════════════════════════════════════════════════
section "CLI Tools"

install_brew() {
  local pkg="$1"
  if ! brew list "$pkg" &>/dev/null; then
    info "Installing $pkg…"
    brew install "$pkg" && log "$pkg installed."
  else
    log "$pkg already installed. Skipping."
  fi
}

install_brew git
install_brew curl
install_brew wget
install_brew fzf
install_brew bat
install_brew eza
install_brew ripgrep
install_brew fd
install_brew tldr
install_brew jq
install_brew tree
install_brew htop
install_brew fastfetch

# fzf key bindings
if command -v fzf &>/dev/null; then
  "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish 2>/dev/null || true
fi

# ── Aliases & shell tweaks ────────────────────────────────────────────────────
ALIASES_BLOCK='
# ── Custom Aliases (added by setup_mac.sh) ────────────────────────────────
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias update="brew update && brew upgrade && brew cleanup"
alias ip="curl ifconfig.me"
alias myip="ipconfig getifaddr en0"
alias reload="source ~/.zshrc"
alias ..="cd .."
alias ...="cd ../.."
alias trash="rm -rf ~/.Trash/*"
alias hidden="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias nohidden="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
# ─────────────────────────────────────────────────────────────────────────────
'

if ! grep -q "Custom Aliases (added by setup_mac.sh)" "$HOME/.zshrc"; then
  echo "$ALIASES_BLOCK" >> "$HOME/.zshrc"
  log "Aliases added to ~/.zshrc"
fi

# ══════════════════════════════════════════════════════════════════════════════
#  8 — FONTS  (Nerd Font for icons in terminal)
# ══════════════════════════════════════════════════════════════════════════════
section "Nerd Font (JetBrainsMono)"
if ! fc-list 2>/dev/null | grep -q "JetBrainsMono" && \
   ! ls ~/Library/Fonts/ 2>/dev/null | grep -q "JetBrains"; then
  info "Installing JetBrainsMono Nerd Font…"
  brew tap homebrew/cask-fonts 2>/dev/null || true
  brew install --cask font-jetbrains-mono-nerd-font && log "Font installed."
else
  log "JetBrainsMono Nerd Font already present. Skipping."
fi

# ══════════════════════════════════════════════════════════════════════════════
#  9 — macOS PERSONALIZATIONS
# ══════════════════════════════════════════════════════════════════════════════
section "macOS Personalizations"

info "Dock: auto-hide, remove magnification delay, faster animation…"
defaults write com.apple.dock autohide -bool true || true
defaults write com.apple.dock autohide-delay -float 0 || true
defaults write com.apple.dock autohide-time-modifier -float 0.4 || true
defaults write com.apple.dock magnification -bool false || true
defaults write com.apple.dock show-recents -bool false          # Hide recent apps in Dock || true
defaults write com.apple.dock tilesize -int 48 || true

info "Finder: show path bar, status bar, extensions, hidden files…"
defaults write com.apple.finder ShowPathbar -bool true || true
defaults write com.apple.finder ShowStatusBar -bool true || true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true || true
defaults write com.apple.finder AppleShowAllFiles -bool false   # set to true if you prefer || true

info "Keyboard: fast key repeat, shorter delay…"
defaults write NSGlobalDomain KeyRepeat -int 2 || true
defaults write NSGlobalDomain InitialKeyRepeat -int 15 || true
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # Allow key repeat || true

info "Trackpad: tap to click, three-finger drag…"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true || true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true || true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true || true

info "Menu bar & UI tweaks…"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"   # Dark mode || true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false || true
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false || true
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false || true
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false || true

info "Mission Control: faster animation…"
defaults write com.apple.dock expose-animation-duration -float 0.1 || true


info "Disable .DS_Store on network & USB drives…"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true || true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true || true

# Restart affected services
for app in Dock Finder SystemUIServer; do
  killall "$app" &>/dev/null || true
done
log "macOS personalization applied."

# ══════════════════════════════════════════════════════════════════════════════
#  10 — SECURITY CHECKS
# ══════════════════════════════════════════════════════════════════════════════
section "Security Checks"

SECURITY_PASS=0; SECURITY_WARN=0

check_sec() {
  local label="$1" result="$2" expected="$3"
  if [[ "$result" == *"$expected"* ]]; then
    log "$label"
    SECURITY_PASS=$((SECURITY_PASS + 1))
  else
    warn "$label — ${RED}ACTION NEEDED${RESET}"
    SECURITY_WARN=$((SECURITY_WARN + 1))
  fi
}

# FileVault
FV=$(fdesetup status 2>/dev/null || echo "unknown")
check_sec "FileVault (disk encryption)" "$FV" "On"
if [[ "$FV" != *"On"* ]]; then
  warn "  → Enable: System Settings → Privacy & Security → FileVault"
fi

# Firewall
FW=$(defaults read /Library/Preferences/com.apple.alf globalstate 2>/dev/null || echo "0")
check_sec "Firewall" "$FW" "1"
if [[ "$FW" == "0" ]]; then
  warn "  → Enable: System Settings → Network → Firewall"
fi

# Gatekeeper
GK=$(spctl --status 2>/dev/null || echo "unknown")
check_sec "Gatekeeper (app signing)" "$GK" "assessments enabled"

# SIP (System Integrity Protection)
SIP=$(csrutil status 2>/dev/null || echo "unknown")
check_sec "System Integrity Protection (SIP)" "$SIP" "enabled"

# Automatic updates
AU=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled 2>/dev/null || echo "0")
check_sec "Automatic update checks" "$AU" "1"

echo ""
echo -e "  Security: ${GREEN}${SECURITY_PASS} passed${RESET}  |  ${YELLOW}${SECURITY_WARN} warnings${RESET}"

# ══════════════════════════════════════════════════════════════════════════════
#  11 — OPEN-SOURCE SECURITY TOOLS
# ══════════════════════════════════════════════════════════════════════════════
section "Open-Source Security Tools"

SEC_TOOLS=(
  "lynis"           # System auditing & hardening advisor
  "nmap"            # Network scanner / port mapper
  "wireshark"       # Network packet analyzer (GUI)
  "netiquette"      # Monitor outgoing network connections (cask)
  "lulu"            # Outbound firewall — block unknown connections (cask)
  "blockblock"      # Persistence monitor — alerts on install attempts (cask)
  "knockknock"      # Persistent software scanner (cask)
  "gpg-suite"       # GPG email/file encryption (cask)
)

# Brew tools
for pkg in lynis nmap; do
  if ! brew list "$pkg" &>/dev/null; then
    info "Installing $pkg…"
    brew install "$pkg" && log "$pkg installed."
  else
    log "$pkg already installed."
  fi
done

# Cask tools
for cask in wireshark lulu blockblock knockknock; do
  if ! brew list --cask "$cask" &>/dev/null; then
    info "Installing $cask…"
    brew install --cask "$cask" && log "$cask installed." || \
      warn "  $cask install failed (may require manual download)."
  else
    log "$cask already installed."
  fi
done

# Lynis installed — run manually when ready
if command -v lynis &>/dev/null; then
  log "Lynis ready — run a full audit anytime with: sudo lynis audit system"
fi

# ══════════════════════════════════════════════════════════════════════════════
#  12 — VIM SETUP (vim-plug + Gruvbox theme)
# ══════════════════════════════════════════════════════════════════════════════
section "Vim — vim-plug + Gruvbox theme"

# Install vim-plug (plugin manager)
VIMPLUG="$HOME/.vim/autoload/plug.vim"
if [[ ! -f "$VIMPLUG" ]]; then
  info "Installing vim-plug…"
  curl -fLo "$VIMPLUG" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  log "vim-plug installed."
else
  log "vim-plug already present."
fi

# Write ~/.vimrc with Gruvbox + sensible defaults
VIMRC="$HOME/.vimrc"
if ! grep -q "gruvbox" "$VIMRC" 2>/dev/null; then
  info "Writing ~/.vimrc with Gruvbox theme and settings…"
  cat > "$VIMRC" << 'EOF'
" ── Plugins (vim-plug) ────────────────────────────────────────────────────────
call plug#begin('~/.vim/plugged')
  Plug 'morhetz/gruvbox'              " Gruvbox colorscheme
  Plug 'vim-airline/vim-airline'      " Status bar
  Plug 'vim-airline/vim-airline-themes'
  Plug 'preservim/nerdtree'           " File tree  (:NERDTreeToggle)
  Plug 'tpope/vim-commentary'         " gcc to toggle comment
  Plug 'jiangmiao/auto-pairs'         " Auto-close brackets
call plug#end()

" ── Theme ─────────────────────────────────────────────────────────────────────
set background=dark
let g:gruvbox_contrast_dark = 'medium'   " soft / medium / hard
colorscheme gruvbox

" ── Airline ───────────────────────────────────────────────────────────────────
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1

" ── General settings ──────────────────────────────────────────────────────────
syntax on
set number                " Line numbers
set relativenumber        " Relative line numbers
set cursorline            " Highlight current line
set tabstop=2             " 2-space tabs
set shiftwidth=2
set expandtab             " Spaces instead of tabs
set smartindent
set wrap                  " Wrap long lines
set incsearch             " Incremental search
set hlsearch              " Highlight matches
set ignorecase smartcase  " Smart case search
set clipboard=unnamed     " Use macOS clipboard
set mouse=a               " Mouse support
set laststatus=2          " Always show status bar
set encoding=utf-8
set termguicolors         " True color support
set scrolloff=8           " Keep 8 lines above/below cursor
set signcolumn=yes
set updatetime=300

" ── Key mappings ──────────────────────────────────────────────────────────────
let mapleader = " "
nnoremap <leader>n :NERDTreeToggle<CR>    " Space+n → file tree
nnoremap <leader>h :nohlsearch<CR>        " Space+h → clear search highlight
nnoremap <C-s> :w<CR>                     " Ctrl+s → save
inoremap <C-s> <Esc>:w<CR>a
EOF
  log "~/.vimrc written with Gruvbox theme."
else
  log "~/.vimrc already has Gruvbox. Skipping."
fi

# Install plugins headlessly
if command -v vim &>/dev/null && [[ -f "$VIMPLUG" ]]; then
  info "Installing Vim plugins (PlugInstall)…"
  vim -E -s -u "$VIMRC" +PlugInstall +qall 2>/dev/null || \
  vim +PlugInstall +qall &>/dev/null || true
  log "Vim plugins installed."
fi

# ══════════════════════════════════════════════════════════════════════════════
#  13 — WRAP UP
# ══════════════════════════════════════════════════════════════════════════════
section "Done! 🎉"

echo -e "  ${GREEN}${BOLD}Your Mac is set up.${RESET} A few things to do manually:\n"
echo "  1.  Open iTerm2 → Preferences → Profiles → Text → set font to JetBrainsMono Nerd Font"
echo "  2.  Enable FileVault if flagged above: System Settings → Privacy & Security"
echo "  3.  Enable Firewall if flagged: System Settings → Network → Firewall"
echo "  4.  Open LuLu and configure outbound firewall rules"
echo "  5.  Open BlockBlock and enable persistence monitoring"
echo "  6.  Run 'exec zsh' or restart your terminal to load the new zsh theme & plugins"
echo ""
echo -e "  ${CYAN}Useful commands you now have:${RESET}"
echo "    update       → brew update + upgrade + cleanup"
echo "    ll           → eza (better ls with icons)"
echo "    cat <file>   → bat (syntax-highlighted cat)"
echo "    hidden       → toggle hidden files in Finder"
echo ""
echo -e "  Completed at: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
