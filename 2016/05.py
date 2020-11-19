#!/usr/bin/env python3

import re
from hashlib import md5

puzzle = open("./input/05.txt").read().strip()
key = ''
key2 = {}
i = 0
j = 0

while len(key) < 8 or len(key2) < 8:
    attempt = (puzzle+str(i)).encode()
    digest = md5(attempt).hexdigest()

    if digest[:5] == '0'*5:
        if len(key) < 8:
            key += digest[5]
        if digest[5] >= '0' and digest[5] < '8' and digest[5] not in key2:
            key2[digest[5]] = digest[6]
    i += 1


print(key)
print(''.join([x[1] for x in sorted(key2.items())]))
