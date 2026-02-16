{ ... }:

{
  services.udev.extraRules = ''
    # Keep Realtek card reader powered on
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10ec", ATTR{device}=="0x5227", ATTR{power/control}="on"
  '';
}
