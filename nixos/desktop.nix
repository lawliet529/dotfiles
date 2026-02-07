# desktop.nix
{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./desktops/plasma.nix
  ];

  fonts.packages = with pkgs; [
    corefonts
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
    noto-fonts-color-emoji
    redhat-official-fonts
    roboto
  ];

  nixpkgs.overlays = [
    (self: super: { mpv = super.mpv.override { scripts = with self.mpvScripts; [ mpris ]; }; })
  ];

  services.sunshine.enable = true;
  services.sunshine.autoStart = false;
  services.sunshine.capSysAdmin = true;

  services.flatpak.enable = true;

  services.ratbagd.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    #media-session.enable = true;
  };

  environment.systemPackages =
    (with pkgs; [
    ])
    ++ (with pkgs-unstable; [
    ]);
}
