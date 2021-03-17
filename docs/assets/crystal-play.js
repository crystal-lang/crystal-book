document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".crystal-play > pre > code").forEach(function(code) {
    var wrapper = document.createElement("div");
    code.parentNode.replaceChild(wrapper, code);
    var play = new CarcinPlay(code.innerText, wrapper, {language: "crystal"});
  });
});
