{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    hugo
    gnumake
  ];
  shellHook = ''
    alias deploy=".stuff/deploy"
  '';
}
