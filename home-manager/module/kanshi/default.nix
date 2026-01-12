{ pkgs, ... }:

let
  contaThinkpad = "AU Optronics 0x1EAC Unknown";
  lenovoHome = "Lenovo Group Limited LEN P27h-10 0x01010101";
  samsungHome = "Samsung Electric Company S27E390 H4HH204663";
  privateThinkpad = "AU Optronics 0x303E Unknown";
  lenovoOfficeRight = "Lenovo Group Limited LEN T27h-20 VNA49K51";
  lenovoOfficeLeft = "Lenovo Group Limited LEN T27h-20 VNA49K91";
in
{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    settings = [
      {
        profile.name = "conta-undocked";
        profile.outputs = [
          {
            criteria = contaThinkpad;
            mode = "1920x1200";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "conta-home-office";
        profile.outputs = [
          {
            criteria = lenovoHome;
            mode = "2560x1440";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = contaThinkpad;
            mode = "1920x1200";
            scale = 1.5;
            position = "-1280,0"; # 1920 / 1.5 = 1280.0
          }
        ];
      }
      {
        profile.name = "conta-svg-office";
        profile.outputs = [
          {
            criteria = lenovoOfficeLeft;
            mode = "2560x1440";
            scale = 1.0;
            position = "-2560,-500";
          }
          {
            criteria = contaThinkpad;
            mode = "1920x1200";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = lenovoOfficeRight;
            mode = "2560x1440";
            scale = 1.0;
            position = "1920,-500";
          }
        ];
      }
      {
        profile.name = "private-undocked";
        profile.outputs = [
          {
            criteria = privateThinkpad;
            mode = "1600x900";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "private-home-office";
        profile.outputs = [
          {
            criteria = lenovoHome;
            mode = "1920x1080";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = samsungHome;
            mode = "1600x900";
            scale = 1.0;
            position = "1920,0";
          }
          {
            criteria = privateThinkpad;
            mode = "1600x900";
            scale = 1.0;
            position = "3520,0";
          }
        ];
      }
    ];
  };
}
