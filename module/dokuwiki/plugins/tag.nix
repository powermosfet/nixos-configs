{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "tag";
  src = pkgs.fetchFromGitHub {
    owner = "dokufreaks";
    repo  = "plugin-tag";
    rev = "d5e67bf3e1824ea785699dec107816ec";
    sha256 = "10ry3am7fqfylz0mda9lybp681x22js1gf2xh5w85jhqlmvzizid";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
