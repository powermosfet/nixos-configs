{ pkgs, ... }:

{
  imports =
    [
    ];

  options = {
  };

  config = {
    services.soft-serve = {
      enable = true;
      settings = {
        name = "Berges repositories";
      };
    };
  };
}