{ pkgs, ... }:

{
  config = {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
