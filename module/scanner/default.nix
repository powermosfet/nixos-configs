{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gscan2pdf
    gocr
  ];

  hardware = {
    sane.enable = true;
  };

  users.users.asmund.extraGroups = [ "scanner" "lp" ];
}


