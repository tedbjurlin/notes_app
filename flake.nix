{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustVersion = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        });

      in {
        devShells.default = pkgs.mkShell rec {
          name = "Notes App";
          buildInputs = with pkgs; [
              rustVersion
              pkg-config
              openssl
              libxkbcommon
              xorg.libX11
              xorg.libXcursor
              xorg.libxcb
              xorg.libXi
              libGL
            ];
          packages = with pkgs; [
            just
          ];
          LD_LIBRARY_PATH = "${nixpkgs.lib.makeLibraryPath buildInputs}";
        };
      });
}
