{
  programs.nixvim = {
    enable = true;

    # Color scheme
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        contrast = "hard"; # Options: "hard", "medium", "soft"
        transparent_mode = false;
      };
    };

    # General options
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;

      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;

      # Appearance
      termguicolors = true;
      wrap = true;
      linebreak = true;
      
      # Spell checking - enabled by default for markdown and latex
      spell = false; # We'll enable per-filetype
      spelllang = "en_us";
      
      # Better editing experience
      undofile = true;
      swapfile = false;
      backup = false;
    };

    # Autocommands for spell checking
    autoCmd = [
      # Enable spell check for markdown files
      {
        event = ["FileType"];
        pattern = ["markdown" "md"];
        command = "setlocal spell spelllang=en_us";
      }
      # Enable spell check for LaTeX files
      {
        event = ["FileType"];
        pattern = ["tex" "latex"];
        command = "setlocal spell spelllang=en_us";
      }
      # Enable spell check for text files
      {
        event = ["FileType"];
        pattern = ["text" "txt"];
        command = "setlocal spell spelllang=en_us";
      }
    ];

    # Keymaps
    keymaps = [
      # Spell checking navigation
      {
        mode = "n";
        key = "]s";
        action = "]s";
        options.desc = "Next spelling error";
      }
      {
        mode = "n";
        key = "[s";
        action = "[s";
        options.desc = "Previous spelling error";
      }
      {
        mode = "n";
        key = "z=";
        action = "z=";
        options.desc = "Spelling suggestions";
      }
      {
        mode = "n";
        key = "zg";
        action = "zg";
        options.desc = "Add word to dictionary";
      }
      {
        mode = "n";
        key = "zw";
        action = "zw";
        options.desc = "Mark word as misspelled";
      }
      
      # LaTeX specific - quick compile
      {
        mode = "n";
        key = "<leader>ll";
        action = "<cmd>VimtexCompile<CR>";
        options.desc = "LaTeX compile";
      }
      {
        mode = "n";
        key = "<leader>lv";
        action = "<cmd>VimtexView<CR>";
        options.desc = "LaTeX view PDF";
      }
      
      # Markdown preview
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>MarkdownPreview<CR>";
        options.desc = "Markdown preview";
      }
    ];

    # Plugins
    plugins = {
      # LSP Configuration
      lsp = {
        enable = true;
        servers = {
          # LaTeX language server
          texlab = {
            enable = true;
            settings = {
              texlab = {
                build = {
                  executable = "latexmk";
                  args = [ "-pdf" "-interaction=nonstopmode" "-synctex=1" "%f" ];
                  onSave = true;
                };
                forwardSearch = {
                  executable = "zathura";
                  args = [ "--synctex-forward" "%l:1:%f" "%p" ];
                };
                chktex = {
                  onEdit = false;
                  onOpenAndSave = true;
                };
              };
            };
          };
          
          # Markdown language server
          marksman.enable = true;
          
          # Grammar and spell checking via LTeX
          ltex = {
            enable = true;
            settings = {
              ltex = {
                language = "en-US";
                enabled = [ "latex" "tex" "markdown" ];
              };
            };
          };
        };
      };

      # LaTeX support
      vimtex = {
        enable = true;
        settings = {
          view_method = "zathura";
          compiler_method = "latexmk";
          quickfix_mode = 0;
        };
      };

      # Treesitter for better syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "spell"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

      # Spell source for completion
      cmp-spell.enable = true;

      # Markdown preview
      markdown-preview = {
        enable = true;
        settings = {
          auto_start = false;
          auto_close = true;
          browser = "";
        };
      };

      # Which-key for keybinding help
      which-key = {
        enable = true;
      };

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            icons_enabled = true;
            theme = "gruvbox";
          };
        };
      };

      # File explorer
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
      };

      # Telescope for fuzzy finding
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
        };
      };

      # Git integration
      gitsigns.enable = true;

      # Comment plugin
      comment.enable = true;

      # Auto-pairs
      nvim-autopairs.enable = true;

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
        };
      };
    };

    # Global settings
    globals = {
      mapleader = " ";
      maplocalleader = " ";
      
      # VimTeX settings
      vimtex_view_method = "zathura";
      vimtex_compiler_method = "latexmk";
    };
  };
}
