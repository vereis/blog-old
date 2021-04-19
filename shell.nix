{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.elixir_1_11
    pkgs.nodejs-15_x
    pkgs.inotify-tools
  ];
}
