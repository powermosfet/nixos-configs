{ ... }:

{
  imports = [
  ];

  config = {
    services.navidrome = {
      enable = true;
      settings = {
        Address = "0.0.0.0";
      };
    };
  };
}
