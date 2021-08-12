{ config, pkgs, ... }:

{
  imports =
    [
    ];

  users.users.asmund = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWxLWJo9pTExwDGYSwxKW5TD2B6ee5lYiEcljruJMaC4O56i88PA/YudngT4ScZBLybwKfLn0RzFITXA8TycRS4Ys/8ODcFodGKY+zoYwyV6K5RGd8+flsBFIlYjbgwy7tvaYdQFKSWX4xoIqipaXNTIaHXiYLiDoE6HXFFNxBX0dwEwBN7pMR9Mb4ZW/SKKfoovLDiLM48Q5KLRx4+eA5OTXHA+/DD0Rov567yVpN+KigtIfrKJhAd6udiAmzebXMMDBM0sCN9qEQy+qauqY5qwmpvnT1O5HOCyL3J2/kAY1PaXFPJLT3PyHmxtZMsZUAiNISOhY2lhFy4sL+vdVsWMH8/Hr+17ftIy5K+jmL4b2T9XhGUFQU54STNYdDDVGxWuL/GwEOJ6gdg2OJSmCe4xUSPyBZZYwu44t/8+ngG/u2ly5COWxHPF1BEUSagAk5XBCIHeLGjyIkPA5q/re5H0YDFBqbwrRof+9tneN5M5wg3ALmz+mQjEFRVgp2uNc= asmund@asmund-thinkpad" ]
  };
}

