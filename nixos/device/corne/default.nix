{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vial
  ];
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="4653", ATTRS{idProduct}=="0004", TAG+="uaccess", MODE:="0666"
  '';
}
