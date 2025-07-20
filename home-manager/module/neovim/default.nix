{
  config,
  pkgs,
  pkgsUnstable,
  ...
}:

{
  home.file = {
    ".config/nvim/snippets/package.json".text = import ./snippet/package.json.nix;
    ".config/nvim/snippets/all.json".source = ./snippet/all.json;
    ".config/nvim/snippets/javascript.json".source = ./snippet/javascript.json;
    ".config/nvim/snippets/lilypond.json".source = ./snippet/lilypond.json;
  };

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
    extraLuaConfig = ''
      require("sharedconfig.init")
    '';
    plugins =
      (import ./plugins.nix {
        pkgs = pkgs;
        pkgsUnstable = pkgsUnstable;
      }).plugins;
  };
}
