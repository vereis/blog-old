{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.elixir_1_11
    pkgs.nodejs-10_x
    pkgs.inotify-tools
  ];
}
