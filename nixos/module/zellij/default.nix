{
  config,
  pkgs,
  pkgsUnstable,
  ...
}:

{
  environment.systemPackages = [
    pkgsUnstable.zellij
  ];

  environment.sessionVariables = {
    ZELLIJ_CONFIG_FILE = ./config/config.kdl;
  };
}
