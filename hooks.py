import logging
import os
import re


log = logging.getLogger('mkdocs')
version = os.getenv('CRYSTAL_VERSION', 'latest')


def on_page_markdown(markdown, page, **kwargs):
    path = page.file.src_path

    for bad in re.findall(r'\[\w.*?\]\((?!http)([^ )]*?(?:\.html|/)(?:#[^ )]*?)?)\)', markdown):
        log.warning(f"Documentation file '{path}' contains an internal link that doesn't end with .md: '{bad}'")

    for bad in re.findall(r'\]\(((?:https?://crystal-lang.org/reference)?/[^ )]*?)\)', markdown):
        log.warning(f"Documentation file '{path}' contains an absolute link to the site itself: '{bad}'")

    return markdown.replace(
        'https://crystal-lang.org/api/latest/',
        f'https://crystal-lang.org/api/{version}/'
    )
