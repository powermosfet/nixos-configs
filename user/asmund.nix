{ config, pkgs, ... }:

{
  imports =
    [
    ];

  users.users.asmund = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; 
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+Z3kQtxzH5ILqwsO5jaDI2TKsb+eElOEg9W73yQMEu3ORkpnXjTmh0p9A4RQ2swuyjdBE+exraDVJ3sU7WdM7qc5Qi+MYw5bwbysMiIP2MEWeisFpG7He+bTeenebqfYCPCF/L67yNk3HvoRcMgretoTchnta23afJXW9fIoyCbU+Zdgc3Q3wktasFROaA7JbZKEiuey1yiAplPBSUVM/1M3846XEDDjIFz3PzwdiVkNf32jzOhnG9YXb18cq0AAevxxXRBcvblYzk4gXzKQfcSUVOBmLaFEM/sWunTBVe/Mtlu/FfNjk7zth2OTxXhQhE2VAJGTDU29A3eF3Gwk4Qc6ylGwi7ckKbOKL/6k4JbTKYCqhjJEPMWzQ0EPaqQjZ0/noiSRHsH45yEW4hCfxXDkKwX3n2Z5o+qgr7EpVia7PLwgoI/p2ctAo4UlYo1wrCP/uTBskT/tuDVDgaJo3xj7la/ARwghCUR7oieJ/wSEB5vPxCk1uJAaLiMJHfUE= asmund@asmund-thinkpad"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0oTAf8eK0M4seDjTqBa0r94NLr1qnH/SNP1J0AIyBf/BWqC0+m1jgGN6sHGD/u8MVra9SRrYCVbeCivztE9uFuPNleXtGuvJQS1DJjZL4wDVhY1z/V1q0n6TqwKwGQDlFD0AWN3iL/vcm1ULpxD1y6FaIGyRh1ie6domrzF2NFdYXfVqAG/FFuvcE1Xl+Ui9Fo+IKJLPgslDt0C2Y/9XArG4q2f3WBdFAryPizxXIap2+HEDFRWyqFTaXgtYzKlo5Dj5P2IfDIVmBz/F64YV3bP3fmrM6Waz7YDxZFs8QiU5vtuJ5Pqu1ixXZ+NSELT6TeDFuFyZuEBrZ48IJcmmzqV8L7umDzknyTxhu/abXVrm6umgBeCr5fy3bAUA5aSjTJMdktxqgtzqV28r29b3TOGJ6BmbY1iDpGQfyfsK0Lr5rcb1FLDSmVnAwrqwQ5WxW9HxlXnl0ZSsJGoUVo5ySR1U6dWoxDpLyvK2CZIuYFShYO4P1wLz7EhOyqYhQZtZoM3TEXB5iTegkpGgPjbyBvcF4BoybTm9DXzvKeCLE0nlE1vYvVL5JwvYUhptAO0vOALy4Pxorzo/zaqChfeYM4SucsW+rftDhy2EXrnvTrWP20eYAYE19cEkLBqgV++3J64wf47vmKtpGzrwEKNOgrmidXhcIepGA4TF57GYqCw== asmundberge@Asmunds-MBP.lyse.net"
    ];
  };
}

