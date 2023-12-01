#! /usr/bin/env python3

from __future__ import annotations

from sys import stdin
from dataclasses import dataclass, field
from typing import Iterator
from collections import defaultdict, namedtuple
from functools import reduce

import re

class Point(namedtuple('Point', 'x y')):
    def __add__(self, otherPoint):
        return Point(*map(sum, zip(self, otherPoint)))

@dataclass
class Claim:
    id: int
    leftCorner: Point
    height: int
    length: int

    @staticmethod
    def fromStr(claimStr: str) -> Claim:
        reResult = re.search(r"#(\d+) @ (\d+,\d+): (\d+x\d+)", claimStr)
        id, corner, dimensions = reResult.groups()
        id = int(id)
        corner = Point(*map(int, corner.split(',')))
        height, length = map(int, dimensions.split('x'))

        return Claim(id, corner, height, length)

    @property
    def space(self) -> Iterator[Point]:
        for y in range(self.height):
            for x in range(self.length):
                yield(self.leftCorner + Point(y, x))

@dataclass
class FabricGrid:
    grid: defaultdict[int] = field(default_factory=lambda: defaultdict(lambda: 0))

    def addClaim(self, claim: Claim) -> FabricGrid:
        for point in claim.space:
            self.grid[point] += 1

        return self

    def overlappingFabric(self) -> int:
        return sum(map(lambda x: x > 1, self.grid.values()))
    
    def claimIsSeperate(self, claim: Claim) -> bool:
        return not any(self.grid[point] > 1 for point in claim.space)

claims = [Claim.fromStr(s) for s in stdin]
fabric = reduce(FabricGrid.addClaim, claims, FabricGrid())

print(fabric.overlappingFabric())
print(next(filter(fabric.claimIsSeperate, claims)).id)