{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) haskellPackages;

  haskellDeps = ps: with ps; [
    base
    hakyll
    zlib
  ];

  ghc = haskellPackages.ghcWithPackages haskellDeps;

  nixPackages = [
    ghc
    haskellPackages.cabal-install
  ];
in
pkgs.stdenv.mkDerivation {
  name = "env";
  buildInputs = nixPackages;
}
