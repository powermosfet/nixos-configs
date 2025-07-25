{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../module/zellij
  ];

  users.users.asmund = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+Z3kQtxzH5ILqwsO5jaDI2TKsb+eElOEg9W73yQMEu3ORkpnXjTmh0p9A4RQ2swuyjdBE+exraDVJ3sU7WdM7qc5Qi+MYw5bwbysMiIP2MEWeisFpG7He+bTeenebqfYCPCF/L67yNk3HvoRcMgretoTchnta23afJXW9fIoyCbU+Zdgc3Q3wktasFROaA7JbZKEiuey1yiAplPBSUVM/1M3846XEDDjIFz3PzwdiVkNf32jzOhnG9YXb18cq0AAevxxXRBcvblYzk4gXzKQfcSUVOBmLaFEM/sWunTBVe/Mtlu/FfNjk7zth2OTxXhQhE2VAJGTDU29A3eF3Gwk4Qc6ylGwi7ckKbOKL/6k4JbTKYCqhjJEPMWzQ0EPaqQjZ0/noiSRHsH45yEW4hCfxXDkKwX3n2Z5o+qgr7EpVia7PLwgoI/p2ctAo4UlYo1wrCP/uTBskT/tuDVDgaJo3xj7la/ARwghCUR7oieJ/wSEB5vPxCk1uJAaLiMJHfUE= asmund@asmund-thinkpad"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAluxxVG0IrvHd6hAbSgK88Bwlt0u9/nhnB4adebCAnq asmund@asmund-conta"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpmHnvEtmwwlTs6ZCDJR8tM6sJUW3CZG7ApLdxndsQ4+dP5SoT0XZMnqTEx6vLRfQ+KDxXog1HrkADmZMhFSsrK5fSESGES9iZKb5KOvmBSp/Q4EjgaD2eZSs9zisKo1T2hmS78LlOrlJWQ0VgcSvvadXCiudKFWNPTP4/kfVlG7F5+Lh5hwEhzzeAGQEYzFM53UdWFSa0oe6DLlT4yYT8SyQEznLoPuaF8apBQuedANiQ1a3lQGQBQ9xdPTuPcI+08hykr109OCMR5TaNjtsJnEB1bgXOOAsxlFKs8E52P/ef7nePrDhCs7o7g9zHbNFkaz96bksBj+To/VGPQJy9 JuiceSSH"
    ];
  };

  # any maching with my user should have these basic tools
  environment.systemPackages = with pkgs; [
    git
    curl
    jq
    visidata
    octave
    htop
  ];

  programs.bash = {
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ls = "ls --color=tty";
      conf = "sudo vi /etc/nixos/configuration.nix";
      rebuild = "sudo nixos-rebuild switch";
    };
    shellInit = ''
      function shellWith {
          prompt="\n\[\033[1;32m\][nix-shell (\[\033[1;36m\]$1\[\033[1;32m\]):\w]\$\[\033[0m\] "
          nix-shell -p $1 --command "export PS1=\"$prompt\"; return"
      }
    '';
  };
}
