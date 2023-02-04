{ pkgs, ... }:

{
  imports =
    [ ../../user/asmund
      ../../module/tmux
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
    nextcloud = {
      path = "/mnt/passport/borg-nextcloud";
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCFKotMiXVzlcRvZYfc28720zJDj6G35f/RMAZMMRwjTvJ7YzJOF011SgftkGF9nXodp4ejhOWzPYFBs/BqqSB+Fk+zLTofLAxfMqiZIp5mMKJfvvjgI4SqHMKPvawKi0K+mhDVF7P/IFujf4Omc4QAc4igRa8d7puojN1hg+KlgKNmKb4VkmFJD7oz/G/TcOzlhcer3+PwIt6W+yOVutT8wGWYBqDHVVgMM1O1bMdS7VS20KePCZOzn9fFkTprT2+j4fVI1AdP9O/L7VC+eMFQgu1P1QMHVSh9kgLeIWjJziHYx0VCJyKMrsMBQ6b6mH0klOA7XeXNTBgK9BAN8qA0ohbEaziuq51ji0acxl5JC1QMbw9PbUa0FrF3fb907Xmi60Mi1jE2SJCwePuIrApQ5rfYpg0qnvTToJfInDA91reQ/9Ip+eAHPBDzxjbkR/FURJ0HV92t9FjEjlJj+IjdxY7ZdhXf7OsH5E1sW1U4Vmdok47ZOAfbWrxaK2NS9lk= asmund@asmund-thinkpad"
      ];
    };
  };
}

