{ pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    ripgrep
    tree-sitter
    git
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
        start = (import ./plugins.nix { pkgs = pkgs; }).plugins;
      };
    };
  };
}
