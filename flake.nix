# Complete flake.nix for AMD Desktop with Hyprland + Secure Boot + rEFInd

{
  description = "AMD Desktop NixOS Configuration with Hyprland";

  inputs = {
    # Nixpkgs - Using STABLE 25.05 to avoid Wine breakage in unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager - use the release that matches nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NixVim
    nixvim = {
    	url = "github:nix-community/nixvim";
	inputs.nixpkgs.follows = "nixpkgs";
	};  
    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # NUR
    nur = {
    	url = "github:nix-community/NUR";
	inputs.nixpkgs.follows = "nixpkgs";
       };

    # Lanzaboote for Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # rEFInd Gruvbox Theme
    refind-gruvbox-theme = {
      url = "github:delania-oliveira/refind-gruvbox-theme";
      flake = false;  # This is not a flake, just a plain repo
    };
  };

  outputs = { self, nixpkgs, nixvim, home-manager, hyprland, lanzaboote, refind-gruvbox-theme, ... }@inputs: {
    nixosConfigurations = {
      # CHANGE 'nixOS' to your hostname if different
      nixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { 
          inherit inputs; 
          inherit refind-gruvbox-theme;  # Pass theme to configuration
        };
        
        modules = [
         # Hardware configuration (auto-generated)
          ./hardware-configuration.nix
          
          # Main system configuration
          ./configuration.nix
          
          # ===== LANZABOOTE FOR SECURE BOOT =====
          # Comment out this entire section until you're ready for secure boot
          # See SECURE_BOOT_GUIDE.md for instructions
          
          # lanzaboote.nixosModules.lanzaboote
          # ({ pkgs, lib, ... }: {
          #   # Disable systemd-boot when using lanzaboote
          #   boot.loader.systemd-boot.enable = lib.mkForce false;
             
             # Enable lanzaboote
          #   boot.lanzaboote = {
          #     enable = true;
           #    pkiBundle = "/var/lib/sbctl";
           #  };
          # })
          
          # ===== HOME MANAGER INTEGRATION =====
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            
            # IMPORTANT: Change 'yourusername' to your actual username!
            home-manager.users.kellen = import ./home.nix;
            
            # NixVim temporarily disabled - uncomment when switching back to unstable
             home-manager.sharedModules = [
             nixvim.homeManagerModules.nixvim
             ];
            
            # Pass inputs to home-manager
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
