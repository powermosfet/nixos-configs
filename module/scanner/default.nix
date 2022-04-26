{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gscan2pdf
    ocrmypdf
    gocr
    gnome.simple-scan
  ];

  hardware = {
    sane.enable = true;
  };

  users.users.asmund.extraGroups = [ "scanner" "lp" ];
}


