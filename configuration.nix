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
  # boot.extraModprobeConfig = ''
  #   options snd-intel-dspcfg dsp_driver=1
  # '';
  # options snd-intel-dspcfg dsp_driver=1
  # options ideapad-laptop ec_trigger=1
  # options lenovo-ymc force=1

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_testing;

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

  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

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
  services.gnome = {
    games.enable = true;
  };
  environment.gnome.excludePackages = (
    with pkgs;
    [
      totem
    ]
  );
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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

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
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # firmware settings
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    sof-firmware
    alsa-firmware
  ];

  zramSwap.enable = true;

  programs.dconf.enable = true;
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
    waydroid-helper
    vesktop
    direnv
    rnote
    gh
    vscode-fhs
    zed-editor-fhs
    refine
    aseprite
    krita
    qq
    imagemagick
    nixfmt
    davinci-resolve
    nh
    nil
    # devtools
    ripgrep
    fd
    dust
    # jujutsu stuff
    jujutsu
    jjui
    # some gnome stuff
    wordbook
    # lutris
    gnome-network-displays
    amberol
    # celluloid
    # (mpv.override {
    #   scripts = [
    #     mpvScripts.uosc
    #     mpvScripts.sponsorblock
    #   ];
    # })
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
