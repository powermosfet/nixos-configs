{ pkgs, ... }:

{
  imports =
    [ ../../user/asmund
      ../../module/neovim
      ../../module/avahi
      ../../module/garbage-collection
      ../../module/auto-update
    ];
     
  time.timeZone = "Europe/Oslo";

  networking.hostName = "gilli";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];
  
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.syncthing = {
    enable = true;
    dataDir = "/mnt/passport/backup";
  };

  services.borgbackup.repos = {
    "main-mook" = {
      path = "/mnt/passport/borg";
      authorizedKeysAppendOnly = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuoCpVADabu/4FMl7kv1jh+6tOa8iDIeRk3IpHIXvWgql5haVHX1Pdf1KGULcc1aZ7alPtR8lPRM9QA4N+pqY64eIAVfde1oe0P7h7NCHvwSwuVsXFR4psojWRplOhsgrVEa+tz0kN3At5laxwjM1gDpn2bb1zk8h3ghCa1yF8f6eRizvhNo/s4d5YQotVtF7bSU5N1SWYP4gO3FlOqbhoLsDoa3DYbWDB9h/ossKFDLquO4Pclr1oWNq+xovX+lFwipH+T7o2GUUt45C3eJla9Ooumk2v7IznLiCZQcvSaLBiMA7ax1oAxUTkR/WKZbSGNyUupIF8aNxiRVw7np0gdqCYubFHDh1FgvV+6TWYrGgvBCQPLSTsJLKgaU1M2oElh3qbP4Uqjwr1WR1rE3at3n9k0rGvdk8ISiXZy8jkWaATYOti2avjJ2S0R8NpYYCpUvZho+XJt1dtGh6Qhs+HkOK87Z9VwaNxJGFZZShqku4uSIaXROsxjZPRU/mAXkE= asmund@asmund-thinkpad"
      ];
    };
  };
}

