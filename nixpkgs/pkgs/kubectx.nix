{ pkgs, lib, ... }:

let
  contents = lib.fetchFromGithub {
    owner: "";
    repo: "";
    rev: "";
    sha256: "";

  }
  helloWorld = pkgs.writeShellScriptBin "helloWorld" ''
    echo Hello World
  '';

in {
  environment.systemPackages = [ helloWorld ];
}
