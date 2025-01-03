{
  config,
  pkgs,
  hyprpanel,
  pkgsUnstable,
  nixvim,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fabric";
  home.homeDirectory = "/home/fabric";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    git
    kitty
    firefox
    mpv
    nerdfonts
    tmux
    discord
    fzf
    yazi
    zsh
    pavucontrol
    wofi
    deno
    hyprpanel
    alejandra
    rustup
    tmuxPlugins.sensible
    tmuxPlugins.vim-tmux-navigator
    tmuxPlugins.onedark-theme
    nodePackages.prettier
    nodePackages.tailwindcss
    prettierd
    nodejs_23
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "zsh";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      oh-my-zsh = {
        enable = true;
      };
      initExtra = ''
        export PATH="/home/fabric/.deno/bin:$PATH"
      '';
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "easy-term";
    };

    nixvim = {
      enable = true;
      plugins = {
        web-devicons.enable = true;
        nix.enable = true;
        bufferline.enable = true;
        lualine.enable = true;
        luasnip.enable = true;
        yanky = {
          enable = true;
          settings = {
            highlight.timer = 150;
          };
        };
        telescope = {
          enable = true;
          keymaps = {
            "<leader> " = {
              action = "git_files";
            };
          };
          settings = {
            defaults = {
              file_ignore_patterns = [
                "^.git/"
                "^.mypy_cache/"
                "^__pycache__/"
                "^output/"
                "^data/"
                "%.ipynb"
                "^node_modules/"
                "^.next/"
                "%.env"
                "%.env.local"
                "%.env.development.local"
                "%.env.test.local"
                "%.env.production.local"
                "^npm-debug.log"
                "^yarn-debug.log"
                "^yarn-error.log"
                "^.vercel/"
                "^.turbo/"
                "^build/"
                "^.DS_Store"
                "^.tailwindcss/"
                "^tailwind.config.js.backup"
                "%.css.map"
                "^styles/dist/"
              ];
            };
          };
        };
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
            auto_install = true;
            ensure_installed = [
              "bash"
              "c"
              "diff"
              "html"
              "javascript"
              "jsdoc"
              "json"
              "jsonc"
              "lua"
              "luadoc"
              "luap"
              "markdown"
              "markdown_inline"
              "printf"
              "python"
              "query"
              "regex"
              "toml"
              "tsx"
              "typescript"
              "vim"
              "vimdoc"
              "xml"
              "yaml"
            ];
          };
        };
        snacks = {
          enable = true;
        };
        indent-blankline.enable = true;
        harpoon = {
          enable = true;
          keymaps = {
            addFile = "<leader>a";
            toggleQuickMenu = "<C-e>";
            navFile = {
              "1" = "<leader>6";
              "2" = "<leader>7";
              "3" = "<leader>8";
              "4" = "<leader>9";
            };
          };
        };
        yazi.enable = true;
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            current_line_blame_opts = {
              virt_text = true;
              virt_text_pos = "eol";
            };
            signcolumn = true;
            signs = {
              add = {
                text = "▎";
              };
              change = {
                text = "▎";
              };
              changedelete = {
                text = "▎";
              };
              delete = {
                text = "";
              };
              topdelete = {
                text = "";
              };
              untracked = {
                text = "▎";
              };
            };
            watch_gitdir = {
              follow_files = true;
            };
          };
        };
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              nix = ["alejandra"];
              # Use prettierd first, fallback to prettier
              javascript = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              typescript = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              javascriptreact = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              typescriptreact = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              css = ["prettier"];
              scss = ["prettier"];
              html = ["prettier"];
              json = ["prettier"];
              markdown = ["prettier"];
              # Run on all files
              "_" = ["trim_whitespace" "trim_newlines"];
            };
            format_on_save = {
              timeout_ms = 500;
              lsp_fallback = true;
            };
            formatters = {
              prettier = {
                command = "prettier";
                args = [
                  "--plugin=prettier-plugin-tailwindcss"
                  "--print-width=80"
                  "--tab-width=2"
                  "--use-tabs=false"
                  "--semi=true"
                  "--single-quote=false"
                  "--trailing-comma=es5"
                  "--bracket-spacing=true"
                ];
              };
              # Optional: Add prettierd for faster formatting
              prettierd = {
                command = "prettierd";
                args = ["$FILENAME"];
              };
            };
            # Additional useful settings from the docs
            log_level = "warn";
            notify_on_error = true;
            notify_no_formatters = false;
          };
        };
        which-key.enable = true;
        undotree = {
          enable = true;
        };
        mini = {
          enable = true;
          modules = {
            pairs.enable = true;
            surround.enable = true;
          };
        };
        lsp = {
          enable = true;
          servers = {
            ts_ls.enable = true;
            eslint.enable = true;
            nil_ls.enable = true;
            tailwindcss.enable = true;
          };
        };
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
            ];
            mapping = {
              __raw = ''
                cmp.mapping.preset.insert({
                  ["<C-j>"] = cmp.mapping.select_next_item(),
                  ["<C-k>"] = cmp.mapping.select_prev_item(),
                  ["<Tab>"] = cmp.mapping.confirm(),
                })
              '';
            };
          };
        };
        tmux-navigator.enable = true;
        vim-suda.enable = true;
      };
      globals.mapleader = " ";
      opts = {
        relativenumber = true;
        number = true;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        autoindent = true;
        wrap = false;
        cursorline = true;
        mouse = "a";
        clipboard = "unnamedplus";
        splitright = true;
        splitbelow = true;
        ignorecase = true;
        smartcase = true;
        termguicolors = true;
        signcolumn = "yes";
        scrolloff = 12;
      };
      keymaps = [
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w>h";
          options = {
            desc = "Go to Left Window";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w>j";
          options = {
            desc = "Go to Lower Window";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w>k";
          options = {
            desc = "Go to Upper Window";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w>l";
          options = {
            desc = "Go to Right Window";
            remap = true;
          };
        }

        # Window resizing
        {
          mode = "n";
          key = "<C-Up>";
          action = "<cmd>resize +2<cr>";
          options.desc = "Increase Window Height";
        }
        {
          mode = "n";
          key = "<C-Down>";
          action = "<cmd>resize -2<cr>";
          options.desc = "Decrease Window Height";
        }
        {
          mode = "n";
          key = "<C-Left>";
          action = "<cmd>vertical resize -2<cr>";
          options.desc = "Decrease Window Width";
        }
        {
          mode = "n";
          key = "<C-Right>";
          action = "<cmd>vertical resize +2<cr>";
          options.desc = "Increase Window Width";
        }
        {
          action = ":UndotreeToggle<CR>";
          key = "<leader>u";
          mode = ["n"];
        }
        {
          action = ":m '>+1<CR>gv=gv";
          key = "J";
          mode = ["v"];
        }
        {
          action = ":m '<-2<CR>gv=gv";
          key = "K";
          mode = ["v"];
        }
        {
          mode = "n";
          key = "<leader>sv";
          action = "<C-w>v";
        }
        {
          mode = "n";
          key = "<leader>sh";
          action = "<C-w>s";
        }
        {
          mode = "n";
          key = "<leader>e";
          action = ":Yazi<CR>";
        }
        {
          mode = "n";
          key = "<C-d>";
          action = "<C-d>zz";
        }
        {
          mode = "n";
          key = "<C-u>";
          action = "<C-u>zz";
        }
        {
          mode = "x";
          key = "<leader>p";
          action = "\"_dP";
        }
      ];
      colorschemes.rose-pine.enable = true;
    };

    git = {
      enable = true;
      userName = "FabricSoul";
      userEmail = "fabric.soul7@gmail.com";
    };
    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        onedark-theme
        vim-tmux-navigator
      ];

      # General settings
      baseIndex = 1;
      mouse = true;
      keyMode = "vi";

      # Custom key bindings
      extraConfig = ''
        # Set pane base index
        setw -g pane-base-index 1

        # Vi copy mode bindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
        bind-key P paste-buffer
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      '';
    };
    # hyprpanel = {
    #   # Enable the module.
    #   # Default: false
    #   enable = false;
    #
    #   # Automatically restart HyprPanel with systemd.
    #   # Useful when updating your config so that you
    #   # don't need to manually restart it.
    #   # Default: false
    #   systemd.enable = true;
    #
    #   # Add '/nix/store/.../hyprpanel' to the
    #   # 'exec-once' in your Hyprland config.
    #   # Default: false
    #   hyprland.enable = true;
    #
    #   # Fix the overwrite issue with HyprPanel.
    #   # See below for more information.
    #   # Default: false
    #   overwrite.enable = false;
    #
    #   # Import a specific theme from './themes/*.json'.
    #   # Default: ""
    #   theme = "rose_pine_moon_split";
    #
    #   # Configure bar layouts for monitors.
    #   # See 'https://hyprpanel.com/configuration/panel.html'.
    #   # Default: null
    #   layout = {
    #     "bar.layouts" = {
    #       "0" = {
    #         left = ["dashboard" "workspaces" "windowtitle"];
    #         middle = ["clock"];
    #         right = ["volume" "network" "bluetooth" "systray" "media" "notifications"];
    #       };
    #     };
    #   };
    #
    #   # Configure and theme *most* of the options from the GUI.
    #   # See './nix/module.nix:103'.
    #   # Default: <same as gui>
    #   settings = {
    #     bar.launcher.autoDetectIcon = true;
    #     bar.workspaces.show_icons = true;
    #
    #     menus.clock = {
    #       time = {
    #         military = true;
    #         hideSeconds = false;
    #       };
    #       weather.unit = "metric";
    #     };
    #
    #     menus.dashboard.directories.enabled = false;
    #     menus.dashboard.stats.enable_gpu = true;
    #
    #     theme.bar.transparent = false;
    #
    #     theme.font = {
    #       name = "CaskaydiaCove NF";
    #       size = "16px";
    #     };
    #   };
    # };
    kitty = {
      enable = true;
      settings = {
        # Basic settings
        enable_audio_bell = false;
        font_family = "FiraCodeNerdFont";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = 11;
        background_opacity = "0.80";
        confirm_os_window_close = 0;

        # Basic colors
        foreground = "#CDD6F4";
        background = "#1E1E2E";
        selection_foreground = "#1E1E2E";
        selection_background = "#F5E0DC";

        # Cursor colors
        cursor = "#F5E0DC";
        cursor_text_color = "#1E1E2E";

        # URL underline color
        url_color = "#F5E0DC";

        # Window border colors
        active_border_color = "#B4BEFE";
        inactive_border_color = "#6C7086";
        bell_border_color = "#F9E2AF";

        # OS Window titlebar colors
        wayland_titlebar_color = "#1E1E2E";
        macos_titlebar_color = "#1E1E2E";

        # Tab bar colors
        active_tab_foreground = "#11111B";
        active_tab_background = "#CBA6F7";
        inactive_tab_foreground = "#CDD6F4";
        inactive_tab_background = "#181825";
        tab_bar_background = "#11111B";

        # Mark colors
        mark1_foreground = "#1E1E2E";
        mark1_background = "#B4BEFE";
        mark2_foreground = "#1E1E2E";
        mark2_background = "#CBA6F7";
        mark3_foreground = "#1E1E2E";
        mark3_background = "#74C7EC";

        # The 16 terminal colors
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
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager " = "dolphin";
      "$menu" = "wofi --show drun";

      windowrule = [
        "workspace 6 silent,^(discord)$"
        "workspace 7 silent,^(kitty)$"
        "workspace 8 silent,^(firefox)$"
      ];

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating"
        "$mainMod, SPACE, exec, $menu"
        # "$mainMod, P, pseudo" # dwindle
        # "$mainMod, J, togglesplit" # dwindle

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];
      # monitor = [
      #   "DP-1, 1920x1080@144, 1"
      # ];
    };
  };
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.fontconfig.enable = true;
}
