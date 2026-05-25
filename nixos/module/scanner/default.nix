{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ocrmypdf
    gocr
    airscan
  ];

  hardware = {
    sane = {
      enable = true;
      extraBackends = with pkgs; [
        sane-airscan
      ];
    };
  };
  environment.etc."sane.d/xerox_mfp.conf".text = ''
    tcp 192.168.1.12 9400
  '';

  users.users.asmund.extraGroups = [
    "scanner"
    "lp"
  ];
}
