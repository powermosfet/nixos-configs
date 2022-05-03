{ pkgs, ... }:

{
  imports =
    [
    ];

  settings = {
  };

  config = {
    services.elasticsearch = {
      enable = true;

      plugins = [
        pkgs.elasticsearchPlugins.ingest-attachment
        ];
      extraConf = ''
        '';
  };
}
