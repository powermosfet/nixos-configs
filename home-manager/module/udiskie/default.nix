{ pkgs, ... }:

{
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.pcmanfm}/bin/pcmanfm";
      };
    };
  };
}
