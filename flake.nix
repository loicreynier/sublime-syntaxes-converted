{
  description = "Flake template";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    git-hooks,
    ...
  }: (flake-utils.lib.eachDefaultSystem (
    system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with pkgs; [
          gnused
          # (callPackage ./nix {})
        ];
      };

      checks = {
        pre-commit-check = git-hooks.lib.${system}.run {
          src = "./.";
          excludes = ["flake\.lock"];
          hooks = {
            alejandra.enable = true;
            commitizen.enable = true;
            deadnix.enable = true;
            editorconfig-checker.enable = true;
            markdownlint.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
            statix.enable = true;
            typos.enable = true;
          };
        };
      };
    }
  ));

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
