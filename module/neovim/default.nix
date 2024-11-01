{ pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  environment.systemPackages = with pkgs; [
    ripgrep
    tree-sitter
  ];

  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    package = unstable.neovim-unwrapped;

    configure = {
      customRC = ''
        set runtimepath^=${./config}
        lua << EOF
          require("sharedconfig.init")
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
