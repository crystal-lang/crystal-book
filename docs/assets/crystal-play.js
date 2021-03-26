document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".crystal-play > pre > code").forEach(function(code) {
    var wrapper = document.createElement("div");
    var parent = code.parentNode;
    parent.replaceChild(wrapper, code);
    var play = new CarcinPlay(code.innerText, wrapper, {language: "crystal"});

    // TODO: Enable clipboard from codemirror
    var clipboardButton = parent.querySelector("button[data-clipboard-target");
    parent.removeChild(clipboardButton);

    /*
    if(ClipboardJS.isSupported()){
      var clipboardButton = parent.querySelector("button[data-clipboard-target");
      clipboardButton.removeAttribute("data-clipboard-target");

      var clipboard = new ClipboardJS(clipboardButton, {
        text: function (trigger) {
            return play.codeMirror.getValue();
        }
      });
    }
    */
  });
});
