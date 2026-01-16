{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      unstable,
    }:
    let
      pkgs-unstable = import unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations."t480" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit pkgs-unstable;
        };
        modules = [
          ./configuration.nix
          ./hardware/t480.nix
        ];
      };
    };
}
