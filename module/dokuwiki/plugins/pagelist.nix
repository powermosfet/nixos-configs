{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "pagelist";
  src = pkgs.fetchzip {
    url = "https://github.com/dokufreaks/plugin-pagelist/archive/refs/heads/master.zip";
    sha256 = "sha256-ATk/qjsFrAOZpfu79Pp+YWtCYnkEJ7fSaTHanOS5wMg=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
