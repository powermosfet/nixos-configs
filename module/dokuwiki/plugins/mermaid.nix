{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "mermaid";
  src = pkgs.fetchzip {
    url = "https://github.com/RobertWeinmeister/dokuwiki-mermaid/archive/refs/heads/main.zip";
    sha256 = "sha256-6t2ehpPmh8C8fYa+SFlnGav8/A4miuDtZ7fqH/eoVeM=";
  };
  sourceRoot = ".";
  installPhase = "mkdir -p $out; cp -R source/* $out/";
}
