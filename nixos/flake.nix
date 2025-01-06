{
  description = "Minimal NixOS configuration";

  # Nixpkgs input (the Nix packages collection)
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.test = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [];
    };
  };
}
