{ pkgs, ... }:

{
  packages = [
    pkgs.gnumake
  ];

  languages.python = {
    enable = true;
    package = pkgs.python311;
    venv = {
      enable = true;
      requirements = ./requirements.txt;
    };
  };

  scripts = {
    "build".exec = "make clean build MKDOCS=mkdocs";
  };

  processes = {
    serve.exec = "make serve MKDOCS=mkdocs";
  };
}
