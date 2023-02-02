{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "tag";
  src = pkgs.fetchFromGitHub {
    owner = "dokufreaks";
    repo  = "plugin-tag";
    rev = "d4b003e4ebaf0a58926ec3efbd78798e5876153d";
    sha256 = "10ry3am7fqfylz0mda9lybp681x22js1gf2xh5w85jhqlmvzizid";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
