{ pkgs, ... }:

{
  imports =
    [
    ];

  options = {
  };

  config = {
    services.matrix-synapse = {
      enable = true;
    };
  };
}
