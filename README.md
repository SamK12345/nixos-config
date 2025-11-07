# My NixOS Configuration

Personal NixOS configuration for AMD desktop with Hyprland.

## Hardware

- **CPU:** AMD Ryzen 7
- **GPU:** AMD Radeon RX 7800 XT
- **Boot:** Secure Boot enabled (PreLoader + systemd-boot)

## Features

- **Desktop:** Hyprland (Wayland compositor)
- **Theme:** Catppuccin Mocha
- **Terminal:** Kitty
- **Shell:** Bash with Starship prompt
- **Editor:** Neovim with LSP
- **Bar:** Waybar
- **Launcher:** Rofi
- **Notifications:** Dunst
- **Gaming:** Steam with GameMode and MangoHud

## Structure
```
.
├── flake.nix                 # Flake configuration
├── flake.lock               # Locked dependencies
├── configuration.nix        # System configuration
├── hardware-configuration.nix # Hardware-specific config
└── home.nix                 # Home Manager configuration
```

## Installation

### Fresh Install

1. Boot NixOS installer
2. Clone this repo:
```bash
   git clone https://github.com/YOUR_USERNAME/nixos-config /mnt/etc/nixos
```
3. Generate hardware config:
```bash
   nixos-generate-config --root /mnt
   # Merge with existing hardware-configuration.nix or replace
```
4. Update personal info in:
   - `configuration.nix` (hostname, timezone, username)
   - `home.nix` (username, home directory, git settings)
   - `flake.nix` (hostname, username)
5. Install:
```bash
   nixos-install --root /mnt --flake /mnt/etc/nixos#nixOS
```

### On Existing System

1. Backup current config:
```bash
   sudo cp -r /etc/nixos /etc/nixos.backup
```
2. Clone repo:
```bash
   sudo rm -rf /etc/nixos
   sudo git clone https://github.com/YOUR_USERNAME/nixos-config /etc/nixos
```
3. Update personal settings (see above)
4. Rebuild:
```bash
   sudo nixos-rebuild switch --flake /etc/nixos#nixOS
```

## Usage

### Update System
```bash
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake .#nixOS
```

### Make Changes
```bash
# Edit configs
sudo nano /etc/nixos/configuration.nix

# Test changes
sudo nixos-rebuild test --flake .#nixOS

# Apply changes
sudo nixos-rebuild switch --flake .#nixOS

# Commit changes
cd /etc/nixos
sudo git add .
sudo git commit -m "Description of changes"
sudo git push
```

### Rollback
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous
sudo nixos-rebuild switch --rollback

# Or select specific generation at boot menu
```

## Key Bindings

See [home.nix](home.nix) for full list. Essentials:

- `SUPER + Return` - Terminal
- `SUPER + R` - App launcher
- `SUPER + Q` - Close window
- `SUPER + 1-9` - Switch workspace
- `Print` - Screenshot

## Notes

- **Secure Boot:** Using PreLoader method
- **Dual Boot:** Windows compatibility maintained
- **Cursor:** Bibata-Modern-Classic
- **Hardware-configuration.nix:** Machine-specific, regenerate on new hardware

## Credits

- [NixOS](https://nixos.org/)
- [Hyprland](https://hyprland.org/)
- [Home Manager](https://github.com/nix-community/home-manager)

## License

MIT License - Feel free to use and modify!
