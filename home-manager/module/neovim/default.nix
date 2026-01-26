{
  config,
  pkgs,
  pkgsUnstable,
  ...
}:

let
  snippetFiles = builtins.listToAttrs (
    map (filename: {
      name = ".config/nvim/snippets/${filename}";
      value = {
        source = ./snippet/lang/${filename};
      };
    }) (builtins.attrNames (builtins.readDir ./snippet/lang))
  );
in
{
  home.file = {
    ".config/nvim/snippets/package.json".source = ./snippet/package.json;
  }
  // snippetFiles;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [
      ripgrep
    ];
    extraConfig = ''
      set runtimepath^=${./config}
    '';
    initLua = ''
      require("sharedconfig.init")
    '';
    plugins =
      (import ./plugins.nix {
        pkgs = pkgs;
        pkgsUnstable = pkgsUnstable;
      }).plugins;
  };
}
