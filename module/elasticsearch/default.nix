{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    services.elasticsearch = {
      enable = true;

      package = pkgs.elasticsearch7;
      plugins = [
        pkgs.elasticsearchPlugins.ingest-attachment
        ];
    };
  };
}
