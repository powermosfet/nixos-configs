{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "indexmenu";
  src = pkgs.fetchFromGitHub {
    owner = "samuelet";
    repo  = "indexmenu";
    rev = "dd97c882d257200e48770adb7201313795f37216";
    sha256 = "ayUnYhpx8jOQULs2lsR7+TeXRUHK8110vhfw0BcQX2I=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
