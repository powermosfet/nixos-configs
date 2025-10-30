{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ocrmypdf
    gocr
  ];

  hardware = {
    sane.enable = true;
  };

  users.users.asmund.extraGroups = [
    "scanner"
    "lp"
  ];
}
