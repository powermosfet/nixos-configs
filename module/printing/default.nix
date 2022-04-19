{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.samsungUnifiedLinuxDriver ];
  };
}


