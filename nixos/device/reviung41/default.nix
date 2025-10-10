{ config, ... }:

{
  config = {
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="7807", ATTRS{idProduct}=="dccb", TAG+="uaccess", MODE:="0666"
    '';
  };
}
