{
  description = "AI Chronicles - Daily notes on working with AI assistants";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python311;
        pythonPackages = python.pkgs;

        docs = pkgs.stdenv.mkDerivation {
          name = "ai-chronicles-docs";
          src = ./.;
          buildInputs = [
            pythonPackages.mkdocs
            pythonPackages.mkdocs-material
            pythonPackages.pymdown-extensions
          ];
          buildPhase = ''
            mkdocs build -d $out
          '';
          dontInstall = true;
        };

        devShell = pkgs.mkShell {
          packages = [
            pythonPackages.mkdocs
            pythonPackages.mkdocs-material
            pythonPackages.pymdown-extensions
            pkgs.just
          ];
        };
      in
      {
        packages = {
          default = docs;
          docs = docs;
        };

        devShells.default = devShell;

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "serve-docs" ''
            cd ${./.}
            ${pythonPackages.mkdocs}/bin/mkdocs serve
          ''}";
        };
      }
    );
}
