{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    services.workout-tracker = {
      enable = true;
    };
  };
}
