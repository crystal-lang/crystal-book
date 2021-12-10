import logging
import re

log = logging.getLogger('mkdocs')


def on_page_markdown(markdown, page, **kwargs):
    path = page.file.src_path

    for bad in re.findall(r'\[\w.*?\]\((?!http)([^ )]*?(?:\.html|/)(?:#[^ )]*?)?)\)', markdown):
        log.warning(f"Documentation file '{path}' contains an internal link that doesn't end with .md: '{bad}'")

    for bad in re.findall(r'\]\(((?:https?://crystal-lang\.org/reference)?/[^ )]*?)\)', markdown):
        log.warning(f"Documentation file '{path}' contains an absolute link to the site itself: '{bad}'")

    for m in re.finditer(r'\bhttps?://crystal-lang\.org/api/(?!toplevel|[A-Z])[^ )/]+/([^ )]+\.html\b)', markdown):
        bad, good = m[0], f'https://crystal-lang.org/api/{m[1]}'
        log.warning(
            f"Documentation file '{path}' contains a version-pinned link to the API: '{bad}'\n"
            f"Suggested fix: '{good}'"
        )
