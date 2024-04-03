{
  description = "Run a Unikernel on microvm.nix host";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, microvm }: {
    nixosModules = rec {
      default = solo5-spt;
      solo5-spt.imports = [
        microvm.nixosModules.microvm-options
        ./nixos-modules/solo5-spt.nix
      ];
    };

    nixosConfigurations.test_net = nixpkgs.lib.evalModules {
      specialArgs.pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        self.nixosModules.solo5-spt
        ./examples/test_net.nix
      ];
    };

    packages.x86_64-linux = rec {
      default = test_net;
      test_net = self.nixosConfigurations.test_net.config.microvm.declaredRunner;
    };
  };
}
