{ config, pkgs, ... }:

{
  imports =
    [
    ];

  users.users.asmund = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; 
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWxLWJo9pTExwDGYSwxKW5TD2B6ee5lYiEcljruJMaC4O56i88PA/YudngT4ScZBLybwKfLn0RzFITXA8TycRS4Ys/8ODcFodGKY+zoYwyV6K5RGd8+flsBFIlYjbgwy7tvaYdQFKSWX4xoIqipaXNTIaHXiYLiDoE6HXFFNxBX0dwEwBN7pMR9Mb4ZW/SKKfoovLDiLM48Q5KLRx4+eA5OTXHA+/DD0Rov567yVpN+KigtIfrKJhAd6udiAmzebXMMDBM0sCN9qEQy+qauqY5qwmpvnT1O5HOCyL3J2/kAY1PaXFPJLT3PyHmxtZMsZUAiNISOhY2lhFy4sL+vdVsWMH8/Hr+17ftIy5K+jmL4b2T9XhGUFQU54STNYdDDVGxWuL/GwEOJ6gdg2OJSmCe4xUSPyBZZYwu44t/8+ngG/u2ly5COWxHPF1BEUSagAk5XBCIHeLGjyIkPA5q/re5H0YDFBqbwrRof+9tneN5M5wg3ALmz+mQjEFRVgp2uNc= asmund@asmund-thinkpad"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0oTAf8eK0M4seDjTqBa0r94NLr1qnH/SNP1J0AIyBf/BWqC0+m1jgGN6sHGD/u8MVra9SRrYCVbeCivztE9uFuPNleXtGuvJQS1DJjZL4wDVhY1z/V1q0n6TqwKwGQDlFD0AWN3iL/vcm1ULpxD1y6FaIGyRh1ie6domrzF2NFdYXfVqAG/FFuvcE1Xl+Ui9Fo+IKJLPgslDt0C2Y/9XArG4q2f3WBdFAryPizxXIap2+HEDFRWyqFTaXgtYzKlo5Dj5P2IfDIVmBz/F64YV3bP3fmrM6Waz7YDxZFs8QiU5vtuJ5Pqu1ixXZ+NSELT6TeDFuFyZuEBrZ48IJcmmzqV8L7umDzknyTxhu/abXVrm6umgBeCr5fy3bAUA5aSjTJMdktxqgtzqV28r29b3TOGJ6BmbY1iDpGQfyfsK0Lr5rcb1FLDSmVnAwrqwQ5WxW9HxlXnl0ZSsJGoUVo5ySR1U6dWoxDpLyvK2CZIuYFShYO4P1wLz7EhOyqYhQZtZoM3TEXB5iTegkpGgPjbyBvcF4BoybTm9DXzvKeCLE0nlE1vYvVL5JwvYUhptAO0vOALy4Pxorzo/zaqChfeYM4SucsW+rftDhy2EXrnvTrWP20eYAYE19cEkLBqgV++3J64wf47vmKtpGzrwEKNOgrmidXhcIepGA4TF57GYqCw== asmundberge@Asmunds-MBP.lyse.net"
    ];
  };
}

