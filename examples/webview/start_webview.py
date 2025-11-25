import argparse
import logging
import pydbus

from time import sleep

logging.basicConfig(level=logging.INFO)

def main():
    parser = argparse.ArgumentParser(description='WebView Sandbox')
    parser.add_argument(
        '--uri',
        type=str,
        default='',
        help='URI of the content to be displayed'
    )
    parser.add_argument(
        '--content-type',
        type=str,
        choices=['image', 'web'],
        default='image',
        help='Type of content to display'
    )

    args = parser.parse_args()
    default_uri = (
        'https://www.example.com'
        if args.content_type == 'web'
        else '/app/images/sample-01.webp'
    ) if args.uri == '' else args.uri

    bus = pydbus.SessionBus()
    bus_instance = bus.get('sandbox.webview', '/')
    
    if args.content_type == 'web':
        bus_instance.loadPage(default_uri)
    elif args.content_type == 'image':
        bus_instance.loadImage(default_uri)


if __name__ == '__main__':
    try:
        main()
    except Exception:
        logging.error('An error occurred.')
        raise
