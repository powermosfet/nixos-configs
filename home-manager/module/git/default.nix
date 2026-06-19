{ ... }:

{
  programs.git = {
    enable = true;
  };
  programs.git-worktree-switcher = {
    enable = true;
    enableZshIntegration = true;
  };
}
