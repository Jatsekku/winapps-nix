{
  description = "WinApps managed by Nix";

  # Flake inputs
  inputs = {
    # Nix Packages collection & NixOS.
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Run Windows apps in Linux
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      # List of all supported systems
      supportedSystems = inputs.nixpkgs.lib.systems.flakeExposed;

      # Function for providing system-specific attributes
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            # Nixpkgs configured per system
            pkgs = import inputs.nixpkgs {
              inherit system;
            };
            inherit system;
          }
        );

    in
    {
      # Provide packages
      packages = forEachSupportedSystem (
        { pkgs, system }:
        {
          # Expose packages
          winapps = inputs.winapps.packages.${system}.winapps;
          winapps-launcher = inputs.winapps.packages.${system}.winapps-launcher;
        }
      );

      # Inject packages via overlays
      overlays.default = final: prev: {
        inherit (self.packages.${final.system})
          winapps
          winapps-launcher
          ;
      };

      # Provide Home Manager modules
      homeManagerModules = {
        winapps = { pkgs, lib, ... }: {
          # Import the pure file directly here
          imports = [ ./nix/winapps-hm.nix ];

          # Inject the default packages
          programs.winapps.package = lib.mkDefault self.packages.${pkgs.system}.winapps;
          programs.winapps.launcherPackage = lib.mkDefault self.packages.${pkgs.system}.winapps-launcher;
        };
        default = self.homeManagerModules.winapps;
      };

      # Set formatter for Nix
      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
