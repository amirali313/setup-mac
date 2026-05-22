# macOS Setup

Automated macOS setup script — Homebrew, iTerm2, Oh My Zsh, security hardening, and curated apps, all in one run.

---

## What it does

Run once on a fresh Mac and get a fully configured machine — terminal, apps, system tweaks, and security checks without clicking through a single preferences pane.

---

## Usage

```bash
chmod +x setup_mac.sh && ./setup_mac.sh
```

> Requires macOS 12 Monterey or later. Tested on Apple Silicon and Intel.

---

## What gets installed

### Terminal
- [Homebrew](https://brew.sh) — package manager
- [iTerm2](https://iterm2.com) — terminal emulator
- [Oh My Zsh](https://ohmyz.sh) — zsh framework
- [zsh313](https://github.com/amirali313/zsh313-theme) — zsh theme
- `zsh-autosuggestions` + `zsh-syntax-highlighting` — plugins
- JetBrainsMono Nerd Font — icons & glyphs in terminal

### Apps
| App | Purpose |
|---|---|
| [Brave](https://brave.com) | Default browser |
| [Rectangle](https://rectangleapp.com) | Window management |
| [Stats](https://github.com/exelban/stats) | Menu bar system monitor |
| [ProtonVPN](https://protonvpn.com) | VPN |
| [Proton Drive](https://proton.me/drive) | Encrypted cloud storage |
| [VS Code](https://code.visualstudio.com) | Code editor |
| [VLC](https://www.videolan.org) | Media player |
| [DisplayLink Manager](https://www.synaptics.com/products/displaylink-graphics/downloads/macos) | Multi-monitor driver *(manual install — opened automatically)* |

### CLI Tools
`git` `curl` `wget` `fzf` `bat` `eza` `ripgrep` `fd` `tldr` `jq` `tree` `htop` `neofetch`

### Vim
- [vim-plug](https://github.com/junegunn/vim-plug) — plugin manager
- [Gruvbox](https://github.com/morhetz/gruvbox) — colorscheme
- [vim-airline](https://github.com/vim-airline/vim-airline) — status bar
- [NERDTree](https://github.com/preservim/nerdtree) — file tree (`Space + n`)
- [vim-commentary](https://github.com/tpope/vim-commentary) — toggle comments (`gcc`)
- [auto-pairs](https://github.com/jiangmiao/auto-pairs) — auto-close brackets

---

## macOS Tweaks

- Dock auto-hide with no delay
- Dark mode
- Tap-to-click + three-finger drag
- Fast key repeat
- Finder path bar, status bar, and file extensions visible
- Autocorrect and autocapitalization disabled
- `.DS_Store` disabled on USB and network drives

---

## Security

### Checks
The script audits the following and warns if action is needed:

- FileVault (disk encryption)
- Firewall
- Gatekeeper
- System Integrity Protection (SIP)
- Automatic update checks

### Tools installed
| Tool | Purpose |
|---|---|
| [LuLu](https://objective-see.org/products/lulu.html) | Outbound firewall — blocks unknown connections |
| [BlockBlock](https://objective-see.org/products/blockblock.html) | Alerts on persistence installs |
| [KnockKnock](https://objective-see.org/products/knockknock.html) | Scans everything that runs at startup |
| [Lynis](https://cisofy.com/lynis/) | Full system hardening audit |
| [nmap](https://nmap.org) | Network/port scanner |
| [Wireshark](https://www.wireshark.org) | Packet analyzer |

Run a full Lynis audit anytime with:
```bash
sudo lynis audit system
```

---

## After running

A few things that still require manual steps:

1. **iTerm2** → Preferences → Profiles → Text → set font to `JetBrainsMono Nerd Font`
2. **FileVault** → System Settings → Privacy & Security → FileVault (if flagged)
3. **Firewall** → System Settings → Network → Firewall (if flagged)
4. **LuLu** → open and configure outbound firewall rules
5. **BlockBlock** → open and enable persistence monitoring
6. **DisplayLink** → System Settings → Privacy & Security → allow the system extension
7. Restart terminal or run `exec zsh` to load the new theme and plugins

---

## Handy aliases added

| Alias | Does |
|---|---|
| `update` | `brew update && brew upgrade && brew cleanup` |
| `ll` | `eza -lah --icons` |
| `cat` | `bat` (syntax-highlighted) |
| `grep` | `rg` (ripgrep) |
| `find` | `fd` |
| `ip` | public IP via `curl ifconfig.me` |
| `hidden` | toggle hidden files in Finder |
| `reload` | `source ~/.zshrc` |
