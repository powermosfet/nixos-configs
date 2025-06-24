{ pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      rtl-sdr
      gnuradio
    ];
    boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  };
}
