from sys import stdin
from itertools import cycle


def findRepeat(frequencies):
    acc, seen = 0, {0}

    for f in cycle(frequencies):
        acc += f
        if acc in seen:
            return acc
        seen.add(acc)


frequencies = list(map(int, stdin.readlines()))

print(sum(frequencies))
print(findRepeat(frequencies))
