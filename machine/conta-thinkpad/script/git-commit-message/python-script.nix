{ pkgs }:

(pkgs.writeTextFile {
  name = "git-commit-message.py";
  text = ''
    #!${pkgs.python3}

    import re, subprocess

    git_result = subprocess.run(["${pkgs.git}/bin/git", "rev-parse", "--abbrev-ref", "HEAD"], capture_output = True)
    branch_string = git_result.stdout.decode("UTF-8")
    result = re.compile("([^/]*)/([0-9]*)").match(branch_string)

    if result:
        (_, number) = result.groups()
        print("AZ-{}: ".format(number), end="")
  '';
})
