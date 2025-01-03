# hosts/common/default.nix
{ config, pkgs, ... }:
{
  # Put all your common configurations here
  # Like basic system settings, networking, users, etc.
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fabric = {
    isNormalUser = true;
    description = "fabric";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    greetd.greetd
    greetd.tuigreet
    libinput
    libnotify
    kitty
    zsh
    home-manager
  ];

  fonts.packages = with pkgs; [nerdfonts];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time ";
        user = "fabric";
      };
    };
  };
  services.displayManager = {
    defaultSession = "hyprland";
  };
  programs = {
    zsh.enable = true;
    hyprland = {
      enable = true;
      # set the flake package
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  };
  virtualisation.docker.enable = true;
  system.stateVersion = "24.11"; # Did you read the comment?
}
