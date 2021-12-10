import os

version = os.getenv('CRYSTAL_VERSION', 'latest')

def on_page_markdown(markdown, **kwargs):
    return markdown.replace(
        'https://crystal-lang.org/api/latest/',
        f'https://crystal-lang.org/api/{version}/'
    )
