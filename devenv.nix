{ pkgs, ... }:

{
  enterShell = ''
    pip install -q -q --no-deps -r requirements.txt
    '';

  packages = [
    pkgs.gnumake
  ];

  languages.python = {
    enable = true;
    venv.enable = true;
  };

  scripts = {
    "build".exec = "make clean build";
  };

  processes = {
    serve.exec = "make serve";
  };

  pre-commit.hooks = {
    markdownlint.enable = true;
  };
}
