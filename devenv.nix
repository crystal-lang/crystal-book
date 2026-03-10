{ pkgs, ... }:

{
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

  git-hooks.hooks = {
    check-toml.enable = true;
    markdownlint.enable = true;
    typos.enable = true;
  };
}
