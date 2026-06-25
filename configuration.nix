# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.sensor.iio.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # fingerprint unlocking
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  networking.hostName = "pokeyoga"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # services.mihomo = {
  #   enable = true;
  #   tunMode = true;
  #   webui = pkgs.metacubexd;
  #   configFile = "/etc/akua.yaml";
  # };
  # networking.firewall = {
  #   enable = false;
  #   trustedInterfaces = [ "tunrouted" ];
  # };

  # mirror providers
  # nix.settings.substituters = [
  #   "https://mirrors.ustc.edu.cn/nix-channels/store"
  # ];

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # auto store optimization
  nix.settings.auto-optimise-store = true;

  # # power optimization
  # powerManagement.powertop.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = [ pkgs.showtime ];
  qt = {
    enable = true;
    style = "adwaita";
    platformTheme = "gnome";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # enable git
  programs.git.enable = true;
  programs.git.lfs.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeremyg = {
    isNormalUser = true;
    description = "Jeremy Gao";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
  };
  users.users.testing = {
    isNormalUser = true;
    description = "Testing";
    extraGroups = [
      "networkmanager"
    ];
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  # firmware settings
  hardware.enableRedistributableFirmware = true;

  zramSwap.enable = true;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # in case if an application likes to look into /usr/bin
  # and doesn't like using /usr/bin/env
  services.envfs.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # theming related
    adw-gtk3
    qadwaitadecorations
    qadwaitadecorations-qt6
    adwaita-qt
    adwaita-qt6
    morewaita-icon-theme
    # sys utils
    wget
    gitui
    vesktop
    direnv
    rnote
    gh
    zed-editor-fhs
    refine
    aseprite
    krita
    qq
    imagemagick
    nixfmt
    nh
    nixd
    # devtools
    ripgrep
    fd
    dust
    # jujutsu stuff
    jujutsu
    jjui
    # some gnome stuff
    wordbook
    bottles
    resources
    wineWow64Packages.stagingFull
    libadwaita
    gnome-network-displays
    amberol
    cine
    gnome-sound-recorder
    # development use
    ungoogled-chromium
  ];

  # bluetooth stuff
  hardware.bluetooth.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
