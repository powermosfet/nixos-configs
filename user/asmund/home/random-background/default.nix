{ pkgs, ... }:

{
  services.random-background = {
    enable = true;

    imageDirectory = "%h/bakgrunner";
    interval = "1h";
  };
}
