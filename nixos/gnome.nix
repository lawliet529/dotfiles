{ config, pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ bamboo ];
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages =
    (with pkgs; [ gnome-tour ])
    ++ (with pkgs.gnome; [
      gnome-software
      gnome-music
      epiphany # web browser
      geary # email reader
      totem # video player
    ]);

  environment.systemPackages = with pkgs; [
    adw-gtk3
    gnome.gnome-tweaks
    gnome.zenity
    (papirus-icon-theme.override { color = "adwaita"; })
  ];
}
