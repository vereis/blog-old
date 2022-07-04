{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  elixir = (beam.packagesWith erlangR23).elixir.override {
    version = "1.13.4";
    sha256 = "1z19hwnv7czmg3p56hdk935gqxig3x7z78yxckh8fs1kdkmslqn4";
  };
in

mkShell {
  buildInputs = [
    elixir
    pkgs.nodejs_latest
    pkgs.inotify-tools
    pkgs.docker-compose
  ];

  shellHook = ''
    unset ERL_LIBS
  '';

  POSTGRES_PORT="1234";
  POSTGRES_USER = "postgres";
  POSTGRES_PASSWORD = "postgres";
  POSTGRES_DB = "blog_dev";

  GITHUB_REPO_NAME = "vereis/blog";
  GITHUB_REPO_ACCESS_TOKEN = "Please configure and source .secrets";
}
