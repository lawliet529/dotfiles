{ config, pkgs, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    # Optional: Set a custom token (default is auto-generated)
    # token = "your-secret-token";
  };

  # Open firewall ports if enabled
  networking.firewall = {
    allowedTCPPorts = [
      6443
      10250
    ];
    allowedUDPPorts = [ 8472 ];
  };

  # Install kubectl for cluster management
  environment.systemPackages = with pkgs; [
    k9s
    kompose
    kubectl
    kubectx
  ];
}
