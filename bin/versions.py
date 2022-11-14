#!/usr/bin/env python
import re
from functools import reduce
from glob import glob

VERSION = re.compile(r'^\s*(?:ARG\s+)?(?P<name>[A-Z]+_VERSION)(?:\s*:=\s*|=)([\'"]?)(?P<value>[a-z]+|\d+(?:\.\d+)*)\2$')
IMAGE_VERSION = re.compile(r'^LABEL\s+org\.opencontainers\.image\.(?P<name>version)="(?P<value>[^"]+)"$')


def max_width(a: dict, b: dict) -> dict:
    return dict(
        file=max(a['file'], len(b['file'])),
        line=max(a['line'], len(str(b['line']))),
        name=max(a['name'], len(b['name'])),
        value=max(a['value'], len(b['value'])),
    )


if __name__ == '__main__':
    versions = []
    for filename in glob('docker/*/*file'):
        with open(filename, mode='rt') as f:
            line = 0
            for s in f:
                line += 1
                if m := (VERSION.fullmatch(s.strip()) or IMAGE_VERSION.fullmatch(s.strip())):
                    versions.append(dict(file=filename, line=line, name=m['name'], value=m['value']))

    versions.sort(key=lambda v: v['name'])
    width = reduce(max_width, versions, dict(file=0, line=0, name=0, value=0))
    
    for v in versions:
        f = re.sub(r'/([^/]+)/', '/\033[1;36m\\1\033[m/', v['file'])
        print(
            f'{f:<{width["file"]+10}}  '
            f'{v["line"]:>{width["line"]}}  '
            f'{v["name"]:<{width["name"]}}  '
            f'{v["value"]}'
        )
