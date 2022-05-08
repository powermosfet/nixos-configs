{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    services.elasticsearch = {
      enable = true;

      package = pkgs.elasticsearch-oss;
      plugins = [
        pkgs.elasticsearchPlugins.ingest-attachment
        ];
    };
  };
}
