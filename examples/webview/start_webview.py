import argparse
import logging
import pydbus

from time import sleep

logging.basicConfig(level=logging.INFO)

def main():
    parser = argparse.ArgumentParser(description='WebView Sandbox')
    parser.add_argument(
        '--url',
        type=str,
        default='https://anthias.screenly.io/',
        help='URL to load in the webview'
    )

    args = parser.parse_args()

    bus = pydbus.SessionBus()
    bus_instance = bus.get('sandbox.webview', '/')
    bus_instance.loadPage(args.url)


if __name__ == '__main__':
    try:
        main()
    except Exception:
        logging.error('An error occurred.')
        raise
