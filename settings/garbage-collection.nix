{ pkgs, ... }:

{
  imports =
    [
    ];
     
    nix.gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "45min";
    };
}


