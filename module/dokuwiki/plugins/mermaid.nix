{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "mermaid";
  src = pkgs.fetchFromGitHub {
    owner = "RobertWeinmeister";
    repo  = "dokuwiki-mermaid";
    rev = "14621dd621e191816a2dea858fe16a5a1411a754";
    sha256 = "6t2ehpPmh8C8fYa+SFlnGav8/A4miuDtZ7fqH/eoVeM=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
