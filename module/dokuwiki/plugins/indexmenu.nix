{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "indexmenu";
  src = pkgs.fetchzip {
    url = "https://github.com/samuelet/indexmenu/archive/refs/heads/master.zip";
    sha256 = "sha256-ayUnYhpx8jOQULs2lsR7+TeXRUHK8110vhfw0BcQX2I=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
