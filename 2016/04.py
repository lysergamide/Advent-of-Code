#!/usr/bin/env python3

import re
import numpy


class Room:
    def __init__(self, hash: str, sector: str, checksum: str) -> None:
        self.hash = hash
        self.sector = int(sector)
        self.checksum = checksum

    def isReal(self) -> bool:
        uniq = list(numpy.unique([c for c in re.sub("-", "", self.hash)]))
        uniq.sort(key=lambda x: (-self.hash.count(x), ord(x)))
        checksum = ''.join(uniq)[:5]
        return checksum == self.checksum

    # sort of caesar shift
    def decrypt(self) -> str:
        def shift(c):
            if c == '-':
                return " "
            else:
                tmp = (ord(c) - ord('a') + self.sector) % 26
                return chr(tmp + ord('a'))

        return ''.join([shift(c) for c in self.hash])


rooms = []
for line in open("input/04.txt").readlines():
    matches = re.search("(^[^\d]+)(\d+)\[(\w+)\]", line)
    tmp = Room(matches.group(1), matches.group(2), matches.group(3))
    if tmp.isReal():
        rooms.append(tmp)

print(sum((x.sector for x in rooms)))
print(next(x for x in rooms if re.search("north", x.decrypt())).sector)
