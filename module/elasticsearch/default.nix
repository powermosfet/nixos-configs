{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    programs.java = {
      package = pkgs.jre;
    };

    services.elasticsearch = {
      enable = true;

      package = pkgs.elasticsearch;
      plugins = [
        pkgs.elasticsearchPlugins.ingest-attachment
        ];
    };
  };
}
