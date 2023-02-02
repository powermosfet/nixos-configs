{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "cloud";
  src = pkgs.fetchFromGitHub {
    owner = "dokufreaks";
    repo  = "plugin-cloud";
    rev = "8a2029eecf28696fda0c5318cc530f2968dde128";
    sha256 = "CiZAE6B4XFCRI7P872AUdZHz6qcMr7x+nY+WK5WbSy8=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
