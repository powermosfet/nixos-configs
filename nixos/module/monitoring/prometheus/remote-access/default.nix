{ ... }:

{
  imports = [
  ];
  options = {
  };

  config = {
    users.users.prometheus.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO49BL6FQP+ie3rocuqBt2Hr9md9eM0+sJHGl6W7Eh0v root@mook"
    ];
  };
}
