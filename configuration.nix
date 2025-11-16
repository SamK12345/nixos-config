# NixOS configuration for AMD-based Desktop 
# Hyprland window manager with Secure/Dual-boot support for Windows
{ config, pkgs, lib, refind-gruvbox-theme, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# ===== BOOTLOADER - rEFInd WITH GRUVBOX THEME ======
 boot.loader = {
   # Disable systemd boot and grub
   systemd-boot.enable = true;
   grub.enable = false;

   # EFI configuration
   efi = {
     canTouchEfiVariables = true;
     efiSysMountPoint = "/boot";
   };
   
   # Enable rEFInd (using built-in NixOS support)
   refind = {
     enable =false;
   }; 
};

  # Install rEFInd Gruvbox theme manually
  system.activationScripts.refind-theme = {
    text = ''
      # Create themes directory if it doesn't exist
      mkdir -p /boot/EFI/refind/themes
      
      # Copy the Gruvbox theme
      ${pkgs.rsync}/bin/rsync -av --delete \
        ${refind-gruvbox-theme}/ \
        /boot/EFI/refind/themes/refind-gruvbox-theme/
      
      # Create or update refind.conf with theme
      REFIND_CONF="/boot/EFI/refind/refind.conf"
      
      # Check if theme is already included
      if ! grep -q "refind-gruvbox-theme/theme.conf" "$REFIND_CONF" 2>/dev/null; then
        echo "" >> "$REFIND_CONF"
        echo "# Gruvbox Theme" >> "$REFIND_CONF"
        echo "include themes/refind-gruvbox-theme/theme.conf" >> "$REFIND_CONF"
      fi
      
      # Add custom configuration if not already present
      if ! grep -q "# Custom NixOS Configuration" "$REFIND_CONF" 2>/dev/null; then
        cat >> "$REFIND_CONF" << 'EOF'

# Custom NixOS Configuration
timeout 5
hideui hints,arrows,badges
big_icon_size 256
small_icon_size 96
showtools shutdown,reboot,memtest,mok_tool,firmware
scanfor manual,external,optical,netboot

# Windows menuentry (adjust path if needed)
menuentry "Windows" {
  icon /EFI/refind/themes/refind-gruvbox-theme/icons/os_win.png
  loader /EFI/Microsoft/Boot/bootmgfw.efi
}
EOF
      fi
    '';
  };
	

 # ====== FLATPAK ======
  services.flatpak.enable = true;
 # ====== KERNEL - Latest Linux headers ======
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
  	#AMDGPU Specific
	"amdgpu.dc=1"
	"amdgpu.ppfeaturemask=0xffffffff"
	"mitigations=off"
	"quiet"
	"splash"
 ];
 # Early KMS for AMD
 boot.initrd.kernelModules = [ "amdgpu" ];

 # Support for some USB (Kobo) devices
 services.udisks2.enable = true;

 # ====== NETWORKING - Wired only ======
 networking.hostName = "NixOS";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Firewall
  networking.firewall.enable=false;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

 # ====== GAMING CONTROLLER ======
  hardware.xpadneo.enable = true;
 # ====== HYPRLAND WINDOW MANAGER ======
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
 }; 
  # Polkit requriment
  security.polkit.enable = true;

  # XDG portal 
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
   ];
 };
  # Display manager - SDDM for now
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
 };

 # ===== TEMP FIX DISABLING PYTHON SELF_CHECKS FOR PYRATE_LIMITER - DISABLE VIA NEXT WEEK =====
 nixpkgs.overlays = [
  (final: prev: {
    python3 = prev.python3.override {
      packageOverrides = pyFinal: pyPrev: {
        pyrate-limiter = pyPrev.pyrate-limiter.overridePythonAttrs (old: {
          doCheck = false;  # Skip tests
        });
      };
    };
    python313 = prev.python313.override {
      packageOverrides = pyFinal: pyPrev: {
        pyrate-limiter = pyPrev.pyrate-limiter.overridePythonAttrs (old: {
          doCheck = false;  # Skip tests
        });
      };
    };
  })
];

 # ===== AMD OPTIMIZATIONS ======
 hardware.graphics = {
   enable = true;

   extraPackages = with pkgs; [
     rocmPackages.clr.icd
     
     # Video Acceleration
     libva
     libvdpau-va-gl
  ];
 # 32-bit driver binaries
 };
 
 # AMDGPU Envs
 environment.variables = {
   # Force AMD RADV
   AMD_VULKAN_ICD = "RADV"; # or "AMDVLK"

   # Video accel
   LIBVA_DRIVER_NAME = "radeonsi";
   VDPAU_DRIVER = "radeonsi";

   # Waylan-specific envs
   WLR_NO_HARDWARE_CURSORS = "1";
   NIXOS_OZONE_WL = "1";
 };

 # ===== AUDIO - PIPEWIRE ======
 services.pipewire = {
   enable = true;
   alsa.enable = true;
   pulse.enable = true;
   jack.enable = true;
   # Low latency 
   extraConfig.pipewire = {
     "context.properties" = {
       "default.clock.rate" = 48000;
       "default.clock.quantum" = 512;
       "default.clock.min-quantum" = 512;
    };
  };
 }; 
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # ===== BLUETOOTH =====
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        JustWorksRepairing = "always";
	Enable = "Source, Sink, Media, Socket";
	Experimental = true;
	fastConnectable = true;
	};
      Input = {
        UserspaceHID = true;
  
     };
   };
 };
   services.blueman.enable = true;

  # ===== PRINTING =====
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
 };

  # ===== USERS =====
  users.users.kellen = {
    isNormalUser = true;
    description = "kellen";
    extraGroups = [ 
    "networkmanager" 
    "wheel"
    "video" 
    "audio"
    "docker"
    "input"
    "render"
    "storage"
  ];
 };

  # ===== SYSTEM PACKAGES ======
  environment.systemPackages = with pkgs; [
    # System Packages
    wget 
    curl 
    git
    neovim
    htop
    btop
    neofetch
    tree
    unzip
    gparted
    zip
    pciutils
    usbutils
    freetype
    fontconfig
    gh

    # Hyprland
    waybar
    dunst
    libnotify
    rofi
    swww
    grim
    slurp
    wl-clipboard
    cliphist
    hyprlock

    # File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # Terminal 
    kitty

    # Email 
    neomutt

    #Docker
    docker-compose
    lazydocker

    #Media server
    htop
    btop
    ncdu

    # Network 
    networkmanagerapplet

    # Browsers
    librewolf

    # Media
    mpv
    pavucontrol

    # AMD ultis
    radeontop
    lm_sensors

    # Wayland untils
    wlr-randr
    wlroots

    # Gaming tools
    mangohud
    gamemode 
    steam
    lutris
    protonup-qt
    
    # Required for theme installation
    rsync
 ];
 
 # ===== FONTS =====
 fonts.packages = with pkgs; [
   noto-fonts
   noto-fonts-cjk-sans
   noto-fonts-color-emoji
   liberation_ttf
   freefont_ttf
   dejavu_fonts
   fira-code
   fira-code-symbols
   font-awesome
   nerd-fonts.fira-code
   nerd-fonts.jetbrains-mono
 ];

 # ===== GAMING =====
  programs.steam = {
    enable = true;
    # This creates an FHS environment for Steam
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
 };
 # GameMode for performace
 programs.gamemode.enable = true;
 
 # ===== NIX SETTINGS =====
 nix.settings = {
   experimental-features = [ "nix-command" "flakes" ];
   auto-optimise-store = true;
 };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

 # ===== GARBAGE COLLECTION =====
 nix.gc = {
   automatic = true;
   dates = "weekly";
   options = "--delete-older-than 7d";
 };
 
 # ===== SECURITY ======
 security.sudo.wheelNeedsPassword = true;
 
 # ===== WINDOWS DUAL BOOT SUPPORT =====
 # Detect Windows Boot Loader
 boot.loader.systemd-boot.configurationLimit = 2;
 boot.loader.timeout = 5;
 # NTFS support
 boot.supportedFilesystems = [ "ntfs" "btrfs" ];

 # ===== PERFORMACE OPTIONS ======
 powerManagement.cpuFreqGovernor = "performance";

 # ===== DOCKER =====
   virtualisation.docker = {
    enable = true;
    
    # Enable rootless mode (more secure, optional)
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    
    # Auto-prune to save disk space
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    
    # Storage driver (optional, zfs if you use ZFS)
    # storageDriver = "overlay2";
  };
 # ===== ZSH =====
 programs.zsh.enable = true;
 system.stateVersion = "25.05";  
}

