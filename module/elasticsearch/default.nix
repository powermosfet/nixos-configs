{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    programs.java = {
      package = pkgs.oraclejre;
    };

    services.elasticsearch = {
      enable = true;

      package = pkgs.elasticsearch;
      plugins = [
        ];
    };
  };
}
