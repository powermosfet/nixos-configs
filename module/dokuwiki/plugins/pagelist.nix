{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "pagelist";
  src = pkgs.fetchFromGitHub {
    owner = "dokufreaks";
    repo  = "plugin-pagelist";
    rev = "54f2dbcf87ab648eda6f41597eb3f6b9696946ef";
    sha256 = "ATk/qjsFrAOZpfu79Pp+YWtCYnkEJ7fSaTHanOS5wMg=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
