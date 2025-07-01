{ pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    settings = [
      {
        profile.name = "conta-undocked";
        profile.outputs = [
          {
            criteria = "AU Optronics 0x1EAC Unknown";
            mode = "1920x1200";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "conta-home-office";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited LEN P27h-10 0x01010101";
            mode = "2560x1440";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = "AU Optronics 0x1EAC Unknown";
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
            criteria = "Lenovo Group Limited LEN T27h-20 VNA49K51";
            mode = "2560x1440";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = "Lenovo Group Limited LEN T27h-20 VNA49K91";
            mode = "2560x1440";
            scale = 1.0;
            position = "-2560,0";
          }
          {
            criteria = "AU Optronics 0x1EAC Unknown";
            mode = "1920x1200";
            scale = 1.5;
            position = "2560,0";
          }
        ];
      }
      {
        profile.name = "private-undocked";
        profile.outputs = [
          {
            criteria = "AU Optronics 0x303E Unknown";
            mode = "1600x900";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "private-home-office";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited LEN P27h-10 0x01010101";
            mode = "1920x1200";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = "Samsung Electric Company S27E390 H4HH204663";
            mode = "1600x900";
            scale = 1.0;
            position = "1920,0";
          }
          {
            criteria = "AU Optronics 0x303E Unknown";
            mode = "1600x900";
            scale = 1.0;
            position = "3520,0";
          }
        ];
      }
    ];
  };
}
