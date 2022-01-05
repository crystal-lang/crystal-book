import logging
import os
import re


log = logging.getLogger('mkdocs')
version = os.getenv('CRYSTAL_VERSION', 'master')


def on_page_markdown(markdown, page, **kwargs):
    path = page.file.src_path

    for bad in re.findall(r'\[\w.*?\]\((?!http)([^ )]*?(?:\.html|/)(?:#[^ )]*?)?)\)', markdown):
        log.warning(f"Documentation file '{path}' contains an internal link that doesn't end with .md: '{bad}'")

    for bad in re.findall(r'\]\(((?:https?://(?:www\.)?crystal-lang\.org/reference)?/[^ )]*?)\)', markdown):
        log.warning(f"Documentation file '{path}' contains an absolute link to the site itself: '{bad}'")

    for m in re.finditer(r'\bhttps?://(www\.)?crystal-lang\.org/api/([0-9]+(\.[0-9]+)+|latest|master)/([^ )]+\.html)\b', markdown):
        bad, good = m[0], f'https://crystal-lang.org/api/{m[4]}'
        log.warning(
            f"Documentation file '{path}' contains a version-pinned link to the API: '{bad}'\n"
            f"Suggested fix: '{good}'"
        )

    return re.sub(
        r'\bhttps?://(www\.)?crystal-lang\.org/api/(?!([0-9]+(\.[0-9]+)+|latest|master)/)',
        f'https://crystal-lang.org/api/{version}/',
        markdown
    )
