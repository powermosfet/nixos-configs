{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "cloud";
  src = pkgs.fetchzip {
    url = "https://github.com/dokufreaks/plugin-cloud/archive/refs/heads/master.zip";
    sha256 = "sha256-CiZAE6B4XFCRI7P872AUdZHz6qcMr7x+nY+WK5WbSy8=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
