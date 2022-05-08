{ pkgs, ... }:

let
  myElasticsearch = pkgs.elasticsearch.override {
    jre_headless = pkgs.oraclejre8;
  };
in
{
  imports =
    [
    ];

  config = {
    nixpkgs.config.allowUnfree = true;

    services.elasticsearch = {
      enable = true;

      package = myElasticsearch;
      plugins = [
        pkgs.elasticsearchPlugins.ingest-attachment
        ];
    };
  };
}
