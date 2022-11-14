#!/usr/bin/env python
import re
from glob import glob


VERSION = re.compile(r'^\s*(?:ARG\s+)?([A-Z]+_VERSION)(?:\s*:=\s*|=)([\'"]?)([a-z]+|\d+(?:\.\d+)*)\2$')


if __name__ == '__main__':
    for filename in glob('docker/*/*file'):
        with open(filename, mode='rt') as f:
            line = 0
            for s in f:
                line += 1
                if m := VERSION.fullmatch(s.strip()):
                    print(f'{filename}:{line}\t{m[1]}\t{m[3]}')
