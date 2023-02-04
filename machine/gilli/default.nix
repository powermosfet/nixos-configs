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
    main = {
      path = "/mnt/passport/borgbackup";
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrIDlc3SHyptGtr6RK2/7by1l4v7vfp4hmr1QlfU7lW5kn7AItVkGhSXzfOSiWTpPvO7IA2x7g//KSevXFO4meuiWXc/KAZVClIL+olGO3ies87HREKqM4lCgsdPDEy5UQyHI+14jAB1hzbhjH6H2dw1cTftEUQ/JumFz4vgZXU6aC7MP+E2DlKwJbCM2X+mj8KJqMprMDlP8QxAJbcZzxx5nGD+MrCm6gLBiXO2XCd+roedfdvAQ3LkraLLHUk8sb7eKKbcX+hUXseQvmhw4daC0gOxRyt4YFrF88Usg77nbBasZ+QF91iX4owr0CR/hXaM3qllOHdSwOe7OkmBABFXlpZc6K44ghIoMMa55M2/OTiS0VvirkShvK87ekvDX0/7D0gTeR9FiOh519J+eMdUiKnZQGTDjhI2vx0GLFI9kutzdeJX+SspEXG4g3sFxAhYTE6WhjCqd2VqXLs1XQw+mrlfzOAbVkrR6S77qPuuoyKdkr50rXWSwDJCqBHGc= asmund@asmund-thinkpad"
      ];
    };
  };
}

