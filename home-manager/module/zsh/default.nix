{ ... }:

{
  programs.zsh = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      filter_mode_shell_up_key_binding = "session";
      enter_accept = true;
    };
  };

  programs.starship = {
    enable = true;

    enableZshIntegration = true;
  };
}
