{ config, ... }:

{
  config = {
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess", MODE:="0666"
    '';
  };
}
