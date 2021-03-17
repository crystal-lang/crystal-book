CodeMirror.keyMap.macDefault["Cmd-Enter"] = "runCode";
CodeMirror.keyMap.macDefault["Cmd-S"] = "runCode";
CodeMirror.keyMap.pcDefault["Ctrl-Enter"] = "runCode";
CodeMirror.keyMap.pcDefault["Ctrl-S"] = "runCode";

CodeMirror.commands.runCode = function(editor) {
  if (editor._play) {
    editor._play.runCode();
  }
};

CarcinPlay = function(code, wrapper, carcinOptions) {
  wrapper.className = "carcin-play"

  var codeMirror = CodeMirror(function(elt) {
    elt.style.height = "auto";
    wrapper.appendChild(elt);
  }, {
    value: code,
    lineNumbers: true,
    tabSize: 2,
    viewportMargin: Infinity,
    theme: "mkdocs-material",
  });

  var actions = document.createElement("div");
  actions.className = "carcin-play__actions";
  var runButton = document.createElement("button");
  runButton.addEventListener("click", function() {
    codeMirror._play.runCode();
  });
  runButton.title = "Run code (Ctrl + Enter)"
  runButton.className = "md-button md-button--primary"
  runButton.innerHTML = "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\"><path d=\"M8 5v14l11-7z\"/></svg>"
  actions.appendChild(runButton);

  wrapper.appendChild(actions);

  var output = document.createElement("div");
  output.className = "carcin-play__output"
  var stdout = document.createElement("code")
  var stdoutPre = document.createElement("pre");
  stdoutPre.className = "carcin-play__stdout"
  stdoutPre.style.display = "none";
  stdoutPre.appendChild(stdout);

  output.appendChild(stdoutPre);
  var stderr = document.createElement("code");
  var stderrPre = document.createElement("pre");
  stderrPre.className = "carcin-play__stderr";
  stderrPre.style.display = "none";
  stderrPre.appendChild(stderr);

  output.appendChild(stderrPre);

  var statusLine = document.createElement("div")
  statusLine.className = "carcin-play__status";
  output.appendChild(statusLine);

  wrapper.appendChild(output);

  codeMirror._play = {
    runCode: function() {
      wrapper.classList.add("loading");
      runButton.disabled = true;

      Carcin.runCode(codeMirror.getValue(), carcinOptions, function(response, error) {
        if(error) {
          console.log(error);
        } else {
          run = response.run;
          if(run.stdout.length == 0) {
            stdoutPre.style.display = "none";
          } else {
            stdoutPre.style.display = "block";
            stdout.innerText = run.stdout
          }

          if(run.stderr.length == 0) {
            stderrPre.style.display = "none";
          } else {
            stderrPre.style.display = "block";
            stderr = Carcin.transformStderr(run.stderr);

            if(window.AnsiUp) {
              const ANSI_UP = new AnsiUp();
              stderr = ANSI_UP.ansi_to_html(stderr);
            }

            stderr.innerHTML = stderr;
          }

          statusLine.innerHTML = "Compiled with " + run.language + " " + run.version + ". Exit code: " + run.exit_code + " (" + run.created_at + ", " +
            "<a href=\"" + run.html_url + "\"><code>" + run.id + "</code></a>)";

          wrapper.classList.remove("loading");
          if(run.exit_code == 0) {
            wrapper.classList.remove("error");
          } else {
            wrapper.classList.add("error");
          }
          runButton.disabled = false;
          console.log(run);
        }
      });
    }
  }
}
