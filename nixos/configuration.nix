# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./gnome.nix
    ./plasma.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "t480"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # DNS
  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    dnsovertls = "true";
  };

  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose"; # Fix no internet when using an exit node

  # Zerotier
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "b612a165ee5c030e"
    ];
  };

  environment.variables = {
    # QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.libsForQt5.qt5.qtbase.bin}/lib/qt-${pkgs.libsForQt5.qt5.qtbase.version}/plugins/platforms";
  };

  # Set your time zone.
  #services.automatic-timezoned.enable = true;
  time.timeZone = "Asia/Ho_Chi_Minh";

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

  fonts.packages = with pkgs; [
    cantarell-fonts
    fira-code
    fira-code-symbols
    iosevka
    jetbrains-mono
    liberation_ttf
    libertine
    meslo-lgs-nf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    redhat-official-fonts
    roboto
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
  services.earlyoom.enable = true;

  virtualisation = {
    podman = {
      enable = false;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "dat" ];

  # services.nexus.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries =
      (with pkgs; [
        alsa-lib
        atk
        cairo
        cups
        dbus
        egl-wayland
        expat
        fontconfig
        freetype
        glib
        gtk3
        krb5
        libdrm
        libsForQt5.qt5.qtbase
        libsForQt5.qt5.qtwayland
        libGL
        libGLU
        libpulseaudio
        libxkbcommon
        mesa
        nspr
        nss
        openssl
        pango
        stdenv.cc.cc
        stdenv.cc.cc.lib
        xcb-util-cursor
      ])
      ++ (with pkgs.xorg; [
        libICE
        libSM
        libX11
        libXau
        libxcb
        libXcomposite
        libXcursor
        libXdamage
        libXdmcp
        libXext
        libXfixes
        libXi
        libXinerama
        libXrandr
        libXrender
        libXtst
      ]);
  };

  services.cron.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.thermald.enable = true;

  services.power-profiles-daemon.enable = false;

  powerManagement.powertop.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 30;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT1 = 75;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };

  services.auto-cpufreq.enable = false;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "powersave";
      turbo = "auto";
    };
    battery = {
      governor = "powersave";
      turbo = "never";
    };
  };

  services.fwupd.enable = true;

  services.flatpak.enable = true;

  # Enable sound with pipewire.
  #hardware.pulseaudio.enable = false;
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
  users.users.dat = {
    isNormalUser = true;
    description = "Dat";
    extraGroups = [
      "networkmanager"
      "wheel"
      "kubernetes"
    ];
    packages = (with pkgs; [ ]) ++ (with pkgs-unstable; [ ]);
    shell = pkgs.zsh;
  };

  nixpkgs.overlays = [
    (self: super: { mpv = super.mpv.override { scripts = with self.mpvScripts; [ mpris ]; }; })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.sunshine.enable = true;
  services.sunshine.autoStart = false;
  services.sunshine.capSysAdmin = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    (with pkgs; [
      nodejs
      yarn
      pnpm
      mpv
      tmux
      compsize
      gh
      hdparm
      mkvtoolnix
      charls
      dcmtk
      lsof
      jetbrains.datagrip
      distrobox
      imagemagick
      nvtopPackages.intel
      age
      alacritty
      android-tools
      apacheHttpd
      appimage-run
      aria2
      asciiquarium
      bat
      beets
      bitwarden-cli
      btop
      cbonsai
      chezmoi
      cmatrix
      croc
      delta
      dig
      dmidecode
      du-dust
      duf
      fastfetch
      fd
      ffmpeg
      ffmpegthumbnailer
      file
      firefox
      glab
      gnumake
      gnupg
      haveged
      home-manager
      htop
      immich-cli
      inetutils
      jetbrains.idea-ultimate
      jq
      libossp_uuid
      linux-wifi-hotspot
      lzip
      mediainfo
      micromamba
      ncdu
      neo
      neovim
      nfs-utils
      nix-output-monitor
      nixfmt-rfc-style
      nmap
      nvme-cli
      obs-studio
      obsidian
      openssl
      qbittorrent
      quickemu
      p7zip
      pandoc
      pass
      patroni
      pciutils
      piper
      postgresql
      putty
      python3
      rclone
      ripgrep
      samba
      sqlite
      sshfs
      starship
      tldr
      tor-browser
      tree
      treefmt
      unzip
      usbutils
      vscode
      wezterm
      wget
      wl-clipboard
      zip
    ])
    ++ (with pkgs-unstable; [
      yt-dlp
    ]);

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
    vim = {
      enable = true;
      defaultEditor = true;
    };
    zsh = {
      enable = true;
      promptInit = "";
      enableCompletion = false;
    };
    gnupg = {
      agent = {
        enable = true;
        pinentryPackage = with pkgs; pinentry-all;
        #enableSSHSupport = true;
      };
    };
  };
  services = {
    pcscd = {
      enable = true;
    };
  };

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
  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1024;
      to = 49151;
    }
    {
      from = 49152;
      to = 65535;
    }
  ];

  services.ratbagd.enable = true;
  programs.direnv.enable = true;
}
