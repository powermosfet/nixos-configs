{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nethack
    blobwars
  ];
}
