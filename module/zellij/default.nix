{
  config,
  pkgs,
  unstable,
  ...
}:

{
  environment.systemPackages = [
    unstable.zellij
  ];

  environment.sessionVariables = {
    ZELLIJ_CONFIG_FILE = ./config/config.kdl;
  };
}
