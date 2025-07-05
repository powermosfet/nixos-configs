{ config, ... }:

{
  config = {
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0478", TAG+="uaccess", MODE:="0666"
    '';
  };
}
