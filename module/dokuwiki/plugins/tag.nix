{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "tag";
  src = pkgs.fetchzip {
    url = "https://github.com/dokufreaks/plugin-tag/archive/refs/heads/master.zip";
    sha256 = "sha256-0ru90nDvePqdcdwVFmeXKatbmXVORx3gtpTRsrdRRMA=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
};
