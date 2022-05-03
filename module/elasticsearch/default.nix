{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    services.elasticsearch = {
      enable = true;

      plugins = [
        pkgs.elasticsearchPlugins.ingest-attachment
        ];
    };
  };
}
