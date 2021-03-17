Carcin = function(){
  this.BASE_URI = "https://carc.in"
  this.runCode = function(code, options, callback) {
    if(callback === undefined) {
      callback = options;
    }
      http = new XMLHttpRequest();
    http.open("POST", this.BASE_URI + "/run_requests");
    http.setRequestHeader("Accept", "application/json, text/javascript");
    http.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

    http.onreadystatechange = function(e) {
      switch(http.readyState) {
        case XMLHttpRequest.DONE:
          status = http.status;
          if (status === 0 || (status >= 200 && status < 400)) {
            callback(JSON.parse(http.responseText).run_request);
          } else {
            callback(null, JSON.parse(http.responseText));
          }
        break;
      }
    }

    http.send(JSON.stringify({
      run_request: Object.assign({
        code: code
      }, options)
    }));
  }

  const PlaypenMessages = {
    'timeout triggered!': 'Execution timed out.',
    'write: Resource temporarily unavailable': 'Execution timed out or too much output.'
  };

  this.transformStderr = function(stderr) {
    stderr = stderr.split("\n").map(function(line) {
      if (line.substr(0, 8) !== 'playpen:') {
        return line;
      }

      for (var message in PlaypenMessages) {
        if (line.substr(9) ===  message) {
          return PlaypenMessages[message];
        }
      }

      return null;
    }).filter(function(line) {
      return line !== null;
    }).join("\n");
    return stderr;
  }

  return this;
}();
