from itertools import (combinations, count)
from copy import deepcopy
from queue import PriorityQueue
import re


class Node:
    def __init__(self, s) -> None:
        path, size, used, avail = re.match(
            r'^([^\s]+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+\d+%', s).groups()  # lol

        self.size = int(size)
        self.used = int(used)
        self.avail = int(avail)

        x, y = re.match(r'.*-x(\d+)-y(\d+)', path).groups()
        self.x = int(x)
        self.y = int(y)


def viable(p):
    a, b = p
    return int(a.used > 0 and a.used <= b.avail) + int(b.used > 0 and b.used <= a.avail)

def neighbors(pos, xmax, ymax):
    x, y = pos
    ret = []

    if x > 0:
        ret.append((x - 1, y))
    if x < xmax:
        ret.append((x + 1, y))
    if y > 0:
        ret.append((x, y - 1))
    if y < ymax:
        ret.append((x, y + 1))

    return ret


# would could probably make an A* solution for this
def gridPrinter(graph):
    i, j = 0, 0
    ymax = max(graph.keys(), key=lambda x: x[0])[0]
    xmax = max(graph.keys(), key=lambda x: x[1])[1]
    cap = min(graph.values(), key=lambda x: x.used).size

    while i <= xmax:
        while j <= ymax:
            if i == 0 and j == ymax:
                print("G", end='')
            elif graph[(j, i)].used > cap:
                print("#", end='')
            elif graph[(j, i)].used == 0:
                print("_", end='')
            else:
                print(".", end='')
            j += 1
        print()
        j = 0
        i += 1


graph = {}
nodes = [Node(l) for l in open('input/22.txt').readlines()[2:]]
for n in nodes:
    graph[(n.x, n.y)] = n

print(sum(map(viable, combinations(nodes, 2))))
gridPrinter(graph)
