{ pkgs, pkgsUnstable, ... }:

{
  services.printing = {
    enable = true;
    package = pkgsUnstable.cups;
    drivers = [ pkgs.samsung-unified-linux-driver ];
  };
}
