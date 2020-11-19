#!/usr/bin/env python3

import re
from itertools import islice


def isTri(arr):
    tmp = arr.copy()
    tmp.sort()
    a, b, c = tmp
    return a + b > c


nums = []
for line in open("input/03.txt").readlines():
    nums.append([int(x) for x in re.split('\s+', line.strip())])

print(sum((1 for x in nums if isTri(x))))

part2 = 0
for i in range(len(nums[0])):
    col = [row[i] for row in nums]
    for j in range(0, len(col), 3):
        if isTri(col[j: j+3]):
            part2 += 1

print(part2)
