{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      intel-compute-runtime
    ];
  };

  boot.kernelParams = [
    "psmouse.synaptics_intertouch=0"
    "i915.enable_psr=0"
  ];
}
