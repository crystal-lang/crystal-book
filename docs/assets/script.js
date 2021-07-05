window.addEventListener('DOMContentLoaded', () => {
    /* Add a blurb when viewing a version that isn't latest */
    fetch("/reference/versions.json").then(res => res.json()).then((json) => {
        var el = document.querySelector(".md-version__current");
        for (var item of json) {
            if (item["aliases"].includes("latest")) {
                if (el.innerHTML.trim() != item["version"]) {
                    el.parentElement.innerHTML += " <small>(outdated)</small>";
                }
                break;
            }
        }
    });
});
