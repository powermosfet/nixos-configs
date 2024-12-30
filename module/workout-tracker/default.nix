{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    services.workout-tracker = {
      enable = true;

      address = "192.168.1.10";
    };
  };
}
