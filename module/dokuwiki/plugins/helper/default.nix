{ pkgs
, name
, owner
, repo
, rev
, sha256
}:

pkgs.stdenv.mkDerivation {
  inherit name;
  src = pkgs.fetchFromGitHub {
    inherit owner repo rev sha256;
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
