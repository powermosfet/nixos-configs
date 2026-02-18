{ pkgs, ... }:

{
  imports = [
    ../../user/asmund
    ../../module/avahi
    ../../module/garbage-collection
    ../../module/auto-update
    ../../module/monitoring/prometheus/exporter/node
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
  services.borgbackup.repos = {
    "main-zook" = {
      path = "/mnt/passport/borg-zook";
      authorizedKeysAppendOnly = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoFFY223kSJ4L20qcN2uuigBQ5w8bhvCewSm5r8Za622bqY01CcJbgIB5UVxPrdgGjgljYcZq5WCLf/3ePvcxX7CrQhuNUEBLupxCUqcBBR/3z7UrPyEfrVJsmPBV8Nbe+8F6AXKhmzP5aS0JCtadc7tJ0t9Fu/kGS46H++w1Qq0YQTtbV/fl6ea/nVjrZkLYkQCcIFmjykada8cePPER2nnIre1dCpHH1hkyxXQrG4JPR+nhBSCoD5euz+5azgN/WdGFMau7xikkIji1OaJpfuKgBOlwYKOoVAAVVvXrcADb4xnoF6z4iIvBYOpOBI77YuYsxmZYIOcBu48CzinAIYngQPthWqS3HWfWu6U3Qv4PQG5jCqs7e7nXu9Y3dhxjX34rZbzX+HDH3HeU8pi8TvrS4obps0IbpGm156gyHfserGTeXkbzMZ3EjzYPBSf9UYT0iJRIavzVmeoZdpQcHMvlf0K6v7uJthDruhQVZ9ooR1X8/TIgoj05G48xIy8Q8j0rwe0ztW7+ExzpAyuODvvE5YplDEv4iFQ766FLi1AQTqNGdRxvY9Nw7oWes8UufncFjDtRzLBfEyG+eZMIph9cqa3SZzE4/AxOSFI0451piapnnoJSPBdB4swCUljpNKXQ0bpLvA7VaM0gVqLD5dueE6wNB9P9b7F6qiHDVQw== root@zook"
      ];
    };
  };
}
