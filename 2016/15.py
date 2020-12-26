from math import gcd
import re


def lcm(a, b):
    return a * b // gcd(a, b)


def solve(discs):
    mod = 1
    time = 0
    while any(map(lambda x: x[0] > 0, discs)):
        for d in filter(lambda d: d[0] == 0, discs):
            mod = lcm(mod, d[1])

        i = next(j for j, d in enumerate(discs) if d[0] > 0)
        steps = (discs[i][1] - discs[i][0])
        t = mod
        while t % discs[i][1] != steps:
            t += mod

        time += t

        for d in discs:
            d[0] = (d[0] + t) % d[1]
    return time


discs = []
for i, line in enumerate(open("./input/15.txt").readlines()):
    mod, start = re.match(r'.*has (\d+).*position (\d+)', line).groups()
    mod = int(mod)
    start = (int(start) + i + 1) % mod
    discs.append([start, mod])

print(solve([x[:] for x in discs]))
print(solve([x[:] for x in discs] + [[len(discs) + 1, 11]]))
