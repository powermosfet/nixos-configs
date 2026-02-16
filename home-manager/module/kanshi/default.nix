{ pkgs, ... }:

let
  thinkpadP14S = "AU Optronics 0x1EAC Unknown";
  samsungHome = "Samsung Electric Company S27E390 H4HH204663";
  thinkpadT440 = "AU Optronics 0x303E Unknown";
in
{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    settings = [
      {
        profile.name = "p14s-undocked";
        profile.outputs = [
          {
            criteria = thinkpadP14S;
            mode = "1920x1200";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "p14s-home-office";
        profile.outputs = [
          {
            criteria = thinkpadP14S;
            mode = "1920x1200";
            scale = 1.5;
            position = "-1280,0"; # 1920 / 1.5 = 1280.0
          }
        ];
      }
      {
        profile.name = "t440-undocked";
        profile.outputs = [
          {
            criteria = thinkpadT440;
            mode = "1600x900";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "t440-home-office";
        profile.outputs = [
          {
            criteria = samsungHome;
            mode = "1600x900";
            scale = 1.0;
            position = "1920,0";
          }
          {
            criteria = thinkpadT440;
            mode = "1600x900";
            scale = 1.0;
            position = "3520,0";
          }
        ];
      }
    ];
  };
}
