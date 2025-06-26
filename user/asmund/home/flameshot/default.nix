{ pkgs, ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = false;
      };
    };
  };
}
