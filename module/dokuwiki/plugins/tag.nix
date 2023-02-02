{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "tag";
  src = pkgs.fetchFromGitHub {
    owner = "dokufreaks";
    repo  = "plugin-tag";
    rev = "d4b003e4ebaf0a58926ec3efbd78798e5876153d";
    sha256 = "0ru90nDvePqdcdwVFmeXKatbmXVORx3gtpTRsrdRRMA=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
