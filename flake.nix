{
  description = "Braden's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs dropped Intel macOS (x86_64-darwin) after 26.05, so the Intel Mac
    # stays on 26.05. It is supported until the end of 2026; after that its
    # package versions are frozen.
    nixpkgs-intel-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    home-manager-intel-darwin = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-intel-darwin";
    };
  };

  outputs =
    inputs:
    let
      mkHome =
        {
          system,
          username,
          homeDirectory,
          modules,
          nixpkgs ? inputs.nixpkgs,
          home-manager ? inputs.home-manager,
          # Where this repo is cloned. Configs are symlinked here (not copied
          # into the Nix store) so edits apply without a rebuild.
          dotfiles ? "${homeDirectory}/code/dotfiles",
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "terraform" ];
              # Intel Mac is knowingly pinned to 26.05 (see inputs).
              allowDeprecatedx86_64Darwin = true;
            };
          };
          extraSpecialArgs = { inherit dotfiles; };
          modules = [
            ./home/common.nix
            { home = { inherit username homeDirectory; }; }
          ]
          ++ modules;
        };
    in
    {
      # Apply with: home-manager switch --flake ~/code/dotfiles#<name>
      homeConfigurations = {
        arch = mkHome {
          system = "x86_64-linux";
          username = "braden";
          homeDirectory = "/home/braden";
          modules = [ ./home/linux.nix ];
        };

        # TODO: confirm username on this machine (`whoami`).
        personal-mac = mkHome {
          system = "x86_64-darwin";
          username = "braden";
          homeDirectory = "/Users/braden";
          modules = [ ./home/darwin.nix ];
          nixpkgs = inputs.nixpkgs-intel-darwin;
          home-manager = inputs.home-manager-intel-darwin;
        };

        work-mac = mkHome {
          system = "aarch64-darwin";
          username = "baltstatt";
          homeDirectory = "/Users/baltstatt";
          modules = [ ./home/darwin.nix ];
        };
      };
    };
}
