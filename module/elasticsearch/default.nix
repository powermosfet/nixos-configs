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

      package = pkgs.elasticsearch7;
      plugins = [
        pkgs.elasticsearchPlugins.ingest-attachment
        ];
    };
  };
}
