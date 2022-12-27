{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ripgrep
  ];

  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    configure = {
      customRC = ''
        set runtimepath^=${./config}
        lua << EOF
          require("init")
        EOF
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          packer-nvim
        ];
      };
    };
  };
}
