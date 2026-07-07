{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    shellWrapperName = "y";
    plugins = with pkgs.yaziPlugins; {
      duckdb = duckdb;
      starship = starship;
      mount = mount;
      diff = diff;
      git = git;
    };
    extraPackages = with pkgs; [ visidata ];

    settings = {
      opener = {
        visidata = [
          {
            run = "vd %s";
            block = true;
            for = "unix";
          }
        ];
      };

      open.prepend_rules = [
        {
          url = "*.csv";
          use = "visidata";
        }
      ];
    };
  };
}
