{ pkgs }:

let
  script = import ./python-script.nix { pkgs = pkgs; };
in
(pkgs.stdenv.mkDerivation {
  name = "git-commit-message";
  dontUnpack = true;
  installPhase = "install -Dm755 ${script} $out/bin/git-commit-msg-template";
})
