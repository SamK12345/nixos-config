{ config, pkgs, ... }:

{
  # IMPORTANT: Change these!
  home.username = "kellen";
  home.homeDirectory = "/home/kellen";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # ===== PACKAGES =====
  home.packages = with pkgs; [
    # CLI tools
    ripgrep
    fd
    bat
    eza
    fzf
    btop
    unzip
    zip
    
    # Wayland screenshot tools
    grim        # Screenshot
    slurp       # Select area
    swappy      # Annotate screenshots

    # ProtonVPN
    wireguard-tools
    #protonvpn-gui

    # Office
    libreoffice-qt
    # Media
    mpv
    imv         # Image viewer
    
    # File manager
    xfce.thunar

    # MPD Clients
    rmpc
    mpc

    mpd-mpris
    playerctl

    # eBook management
    calibre
    # Visualization 
    cava
	
    # Extra gaming
    lutris
    wineWowPackages.stable
    protontricks
    bottles
    winetricks
    
    # System
    networkmanagerapplet
    pavucontrol
    brightnessctl
    
    # Clipboard
    wl-clipboard
    cliphist
    
    # Notifications
    libnotify
  ];

  # ===== HYPRLAND CONFIGURATION =====
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    settings = {
      # Monitor configuration
      monitor = [
        # Change to match your setup
	       "HDMI-A-1,2560x1440@75,0x0,1"
         "DP-1,2560x1440@240,2560x0,1"
      ];
      
      # Autostart
      exec-once = [
        "waybar"
        "dunst"
        "swww-daemon"
        "nm-applet"
        "blueman-applet"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
      
      # Environment variables
      env = [
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
	      "HYPRCURSOR_THEME,Bibata-Modern-Classic"	
      ];
      
      # Input configuration
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        
        follow_mouse = 1;
        
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification
        
        touchpad = {
          natural_scroll = false;
        };
      };
      
      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      
      # Decoration
      decoration = {
        rounding = 10;
        
        active_opacity = 1.0;
        inactive_opacity = 0.95;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      
      # Animations
      animations = {
        enabled = true;
        
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Layouts
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master = {
        new_status = "master";
      };
      
      # Misc
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
      
      # Window rules
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, class:pavucontrol"
        "float, class:blueman-manager"
      ];
      
      # KEY BINDINGS
      "$mod" = "SUPER";
      
      bind = [
        # Application shortcuts
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, thunar"
        "$mod, V, togglefloating,"
        "$mod, D, exec, rofi -show drun"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"

	# Fullscreen on super-F
	"$mod, F, fullscreen" 
        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        
        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        
        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, Print, exec, grim - | swappy -f -"
        
        # Clipboard history
        "$mod, period, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      # Media keys
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
      
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  # ===== WAYBAR CONFIGURATION =====
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        
        modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "clock" "tray" ];
        
        "hyprland/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
        };
        
        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
        };
        
        tray = {
          spacing = 10;
        };
        
        clock = {
          format = "{:%H:%M  %a %b %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        
        memory = {
          format = " {}%";
        };
        
        temperature = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" ""];
        };
        
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-linked = " {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            headphone = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      
      window#waybar {
        background-color: rgba(60, 56, 54, 0.9);
        color: #E2E2E2;
        transition-property: background-color;
        transition-duration: .5s;
      }
      
      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #E2E2E2;
        border-bottom: 3px solid transparent;
      }
      
      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }
      
      #workspaces button.active {
        background-color: #64727d;
        border-bottom: 3px solid #cdd6f4;
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 0 4px;
        color: #cdd6f4;
      }
      
      #temperature.critical {
        background-color: #f38ba8;
        color: #1e1e2e;
      }
      
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
      }
    '';
  };
  # ===== THEMING =====
  # Cursor theme
  home.pointerCursor = {
     gtk.enable = true;
     x11.enable = true; 
     package = pkgs.bibata-cursors;
     name = "Bibata-Modern-Classic";
     size = 24;
  };

  # ===== DUNST (NOTIFICATIONS) =====
  services.dunst = {
    enable = true;
    
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        scale = 0;
        notification_limit = 0;
        
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        indicate_hidden = "yes";
        transparency = 10;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#89b4fa";
        separator_color = "frame";
        
        sort = "yes";
        idle_threshold = 120;
        
        font = "JetBrainsMono Nerd Font 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;
        
        sticky_history = "yes";
        history_length = 20;
        
        browser = "firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };

  # ===== ROFI (APPLICATION LAUNCHER) =====
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    
    theme = "gruvbox-dark-soft";
    
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      sidebar-mode = true;
    };
  };

  # ===== KITTY TERMINAL =====
  programs.kitty = {
    enable = true;
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    
    settings = {
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      
      # Catppuccin Mocha theme
      foreground = "#CDD6F4";
      background = "#32302F";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      # Colors
      color0 = "#45475A";
      color8 = "#585B70";
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };
  };

  # ===== GIT =====
  programs.git = {
    enable = true;
    userName = "Samk12345";
    userEmail = "sampkellen@protonmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  # ===== BASH =====
  programs.bash = {
    enable = true;
    
    shellAliases = {
      ll = "eza -la --git";
      ls = "eza";
      cat = "bat";
      grep = "rg";
      find = "fd";
      vim = "nvim";
      ".." = "cd ..";
      "..." = "cd ../..";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#amd-desktop";
      nrt = "sudo nixos-rebuild test --flake /etc/nixos#amd-desktop";
    };
  };

  # ===== NEOVIM (Optional but recommended) =====
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      colorscheme desert
    '';
  };

  # ===== MUSIC PLAYER DAEMON ======
  services.mpd = {
    enable = true;
    
    # Music directory
    musicDirectory = "~/.docker-media-server/media/music";
    
    # MPD database and state
    dataDir = "${config.home.homeDirectory}/.local/share/mpd";
    
    # Network settings
    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };
    
    # Extra configuration
    extraConfig = ''
      # Audio output to PipeWire
      audio_output {
        type            "pipewire"
        name            "PipeWire Output"
      }
      
      # Optional: HTTP stream output
      audio_output {
        type            "httpd"
        name            "HTTP Stream"
        encoder         "opus"
        port            "8000"
        bitrate         "128000"
        format          "48000:16:2"
        always_on       "yes"
        tags            "yes"
      }
      
      # FIFO output for visualization (cava)
      audio_output {
        type            "fifo"
        name            "FIFO Output"
        path            "/tmp/mpd.fifo"
        format          "44100:16:2"
      }
      
      # Database and state
      auto_update     "yes"
      restore_paused  "yes"
      
      # Logging
      log_level       "default"
    '';
  };

  # ===== RMPC CONFIGURATION =====
  # RMPC uses TOML config at ~/.config/rmpc/config.toml
  xdg.configFile."rmpc/config.toml".text = ''
    # RMPC Configuration
    
    [general]
    # Address of MPD server
    address = "127.0.0.1:6600"
    
    # Music directory (same as MPD)
    music_directory = "${config.home.homeDirectory}/.docker-media-server/media/music"
    
    # Theme
    [theme]
    # Catppuccin Mocha colors
    background = "#1e1e2e"
    foreground = "#cdd6f4"
    
    # Border colors
    border_focused = "#89b4fa"
    border_unfocused = "#45475a"
    
    # Selection colors
    selection_background = "#45475a"
    selection_foreground = "#cdd6f4"
    
    # Progress bar
    progress_bar = "#89b4fa"
    progress_bar_background = "#313244"
    
    # Status colors
    playing = "#a6e3a1"
    paused = "#f9e2af"
    stopped = "#f38ba8"
    
    # Highlight colors
    highlight = "#cba6f7"
    highlight_background = "#313244"
    
    [keybindings]
    # Navigation (Vim-style)
    down = "j"
    up = "k"
    left = "h"
    right = "l"
    
    # Playback
    toggle_playback = "space"
    next_track = "."
    previous_track = ","
    stop = "s"
    
    # Volume
    volume_up = "+"
    volume_down = "-"
    
    # Queue management
    add_to_queue = "a"
    delete_from_queue = "d"
    clear_queue = "c"
    
    # Views
    show_queue = "1"
    show_library = "2"
    show_playlists = "3"
    show_search = "/"
    
    # Other
    update_database = "u"
    quit = "q"
    
    [ui]
    # Show album art (if available)
    show_album_art = true
    
    # Album art size
    album_art_width = 30
    album_art_height = 15
    
    # Progress bar style
    progress_bar_style = "line"  # or "block"
    
    # Show track numbers
    show_track_numbers = true
    
    # Border style
    border_style = "rounded"  # or "plain", "double"
    
    [behavior]
    # Seek increment (in seconds)
    seek_increment = 5
    
    # Volume increment
    volume_increment = 5
    
    # Scroll behavior
    scroll_offset = 5
    
    # Auto-center on current song
    autocenter = true
    
    [lyrics]
    # Enable lyrics display
    enabled = true
    
    # Lyrics directory
    directory = "${config.home.homeDirectory}/.local/share/lyrics"
    
    # Auto-fetch lyrics
    auto_fetch = true
  '';

  # ===== MPC & RMPC ALIASES =====
  programs.bash.shellAliases = {
    # RMPC shortcuts
    mp = "rmpc";
    music = "rmpc";
    
    # MPC shortcuts (for scripting)
    mplay = "mpc play";
    mpause = "mpc pause";
    mnext = "mpc next";
    mprev = "mpc prev";
    mstop = "mpc stop";
    mrandom = "mpc random";
    mrepeat = "mpc repeat";
    mupdate = "mpc update";
    mstatus = "mpc status";
  };

  # ===== MPRIS SUPPORT FOR MEDIA KEYS =====
  systemd.user.services.mpd-mpris = {
    Unit = {
      Description = "MPD MPRIS support";
      After = [ "mpd.service" ];
      Requires = [ "mpd.service" ];
    };
    
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris";
      Restart = "on-failure";
    };
    
    Install = {
      WantedBy = [ "default.target" ];
    };
  };


  # ===== CUSTOM FILES =====
  # Wallpaper script
  home.file.".config/hypr/wallpaper.sh" = {
    text = ''
      #!/bin/sh
      swww img ~/Pictures/wallpaper.jpg --transition-type random
    '';
    executable = true;
  };
}
