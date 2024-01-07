{ pkgs, ... }:

{
  imports =
    [ ../../module/ddclient
      ../../user/asmund
      ../../module/neovim
      ../../module/avahi
      ../../module/garbage-collection
      ../../module/auto-update
    ];
     
  time.timeZone = "Europe/Oslo";

  networking.hostName = "agent25";

  environment.systemPackages = with pkgs; [
    git
  ];
  
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.borgbackup.repos = {
    "main-mook" = {
      authorizedKeysAppendOnly = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmhuYssWYdPft49Cy5PXaYuy9sYU9E3TyyS/icWheXxctKajAypbKrsC6e3FfY8qfT+XgP17hMmpC6/IxpYTK7I39e4GfiBEoMU/YFcO4aPeQV6a7HQIRkXXKuhFRExbbWOhPBfzQ8jX26UzSXj+Xwq2hm42kE873Npe3Gi5P7kk7Z/RTShEWvmpp5JVE/mVL3M4kmzwEdm1TU4zra3iCAtFJ+gzIN7d6Utg99AgvtGhTvl0z5wLZzkuknsUnjNRIIeuhLBT+7VwRwOffJYD8gd8IM8CmTU/qmJosDZN6OrUmA8s9KeCLg4NpUODlZNijYErPHpXLGZJndMwzXhtSJNvrp04fnGVKAFtBzLpNyyr4Sp76LAIInR6ING8N/sD9GuHhmNKMh3ofXsXcR8a8CnNX5RoqnbfqKSkKJw8sf5fQOUyr7OqTHuj16OYJp+h72IN+szTgcxhKkd6c4wIbNmU8lrcU2Lbljvsl6FOuZkIHruax/gTzPMuKUhPZgzdE= asmund@mook"
      ];
    };
  };

  services.ddclient.domains = [ "agent25.berge.id" ];
}

