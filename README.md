# macOS 313

Automated macOS setup script — Homebrew, iTerm2, Oh My Zsh, security hardening, and curated apps, all in one run.

---

## Usage

```bash
chmod +x setup_mac.sh && ./setup_mac.sh
```

> Requires macOS 12 Monterey or later. Tested on Apple Silicon and Intel.

The script is **interactive** — it asks you category by category whether you want to install each section, so you stay in full control of what gets set up.

```
  ◆ Install CLI tools?
    git, bat, eza, fzf, ripgrep, fd, tldr, jq, tree, htop, fastfetch and more

  (y) Yes    (n) No    (q) Quit

  →
```

---

## What gets installed

### Core (always runs)
- [Homebrew](https://brew.sh) — package manager
- Xcode Command Line Tools

### Terminal
- [iTerm2](https://iterm2.com) — terminal emulator
- [Oh My Zsh](https://ohmyz.sh) — zsh framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — zsh theme with interactive config wizard
- `zsh-autosuggestions` + `zsh-syntax-highlighting` — plugins
- JetBrainsMono Nerd Font — icons and glyphs in terminal

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
| Tool | Purpose |
|---|---|
| `git` | Version control |
| `curl` / `wget` | File transfer |
| `fzf` | Fuzzy finder — `Ctrl+R` for interactive history search |
| `bat` | `cat` with syntax highlighting |
| `eza` | Modern `ls` with icons |
| `ripgrep` | Blazing fast `grep` |
| `fd` | Better `find` |
| `tldr` | Simplified man pages |
| `jq` | JSON processor |
| `tree` | Directory tree viewer |
| `htop` | Interactive process viewer |
| `fastfetch` | System info in terminal |

### Vim
- [vim-plug](https://github.com/junegunn/vim-plug) — plugin manager
- [Gruvbox](https://github.com/morhetz/gruvbox) — colorscheme
- [vim-airline](https://github.com/vim-airline/vim-airline) — status bar
- [NERDTree](https://github.com/preservim/nerdtree) — file tree (`Space + n`)
- [vim-commentary](https://github.com/tpope/vim-commentary) — toggle comments (`gcc`)
- [auto-pairs](https://github.com/jiangmiao/auto-pairs) — auto-close brackets

---

## macOS Tweaks

- Dock auto-hide with zero delay, dark mode applied
- Tap-to-click and three-finger drag enabled
- Fast key repeat
- Finder path bar, status bar, and file extensions visible
- Autocorrect and autocapitalization disabled
- `.DS_Store` disabled on USB and network drives
- Dock cleaned up — only Brave, iTerm2, System Settings on the left

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
| [nmap](https://nmap.org) | Network and port scanner |
| [Wireshark](https://www.wireshark.org) | Packet analyzer |

Run a full Lynis audit anytime with:
```bash
sudo lynis audit system
```

---

## Git & GitHub

The script fully sets up Git and GitHub SSH so you can push and pull immediately:

1. Asks for your GitHub username and email
2. Sets git globals (`user.name`, `user.email`, default branch `main`, vim editor)
3. Asks for an SSH key passphrase (hidden input, confirmed twice) for extra security
4. Generates an SSH key (`ed25519`) with your passphrase
5. Adds it to your SSH agent and macOS keychain — so you only type the passphrase once per reboot
6. Copies the public key to clipboard and opens `github.com/settings/keys`
7. Waits for you to add it, then tests the connection automatically

---

## After running

A few things that still require manual steps:

1. **iTerm2** → Preferences → Profiles → Text → set font to `JetBrainsMono Nerd Font`
2. **Powerlevel10k** → runs its config wizard automatically on first terminal open
3. **FileVault** → System Settings → Privacy & Security (if flagged)
4. **Firewall** → System Settings → Network → Firewall (if flagged)
5. **LuLu** → open and configure outbound firewall rules
6. **BlockBlock** → open and enable persistence monitoring
7. **DisplayLink** → System Settings → Privacy & Security → allow the system extension
8. Restart terminal or run `exec zsh` to load the new theme and plugins

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
| `myip` | local IP via `ipconfig getifaddr en0` |
| `hidden` | toggle hidden files in Finder |
| `reload` | `source ~/.zshrc` |
| `trash` | empty the Trash |
| `update` | brew update + upgrade + cleanup |
