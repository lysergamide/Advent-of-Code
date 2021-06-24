import queue
import copy


class Position:
    def __init__(s, y, x): s.y, s.x = y, x
    def __repr__(s): return f"Pos: {(s.y, s.x)}"
    def __hash__(s): return hash((s.y, s.x))
    def __lt__(s, o): return (s.y, s.x) > (o.y, o.x)
    def __eq__(s, o): return hash(s) == hash(o)
    def dist(s, o): return abs(s.y - o.y) + abs(s.x - o.x)

    def nearby(s):
        for i in (1, -1):
            yield Position(s.y + i, s.x)
            yield Position(s.y, s.x + i)


def astar(world, start, end):
    cameFrom, fastest = {}, {}
    q = queue.PriorityQueue()

    def getPath():
        doors = set()
        pos = keys[end]

        while pos != keys[start]:
            if world[pos].isupper():
                doors.add(world[pos])
            pos = cameFrom[pos]

        return (fastest[keys[end]], doors)

    fastest[keys[start]] = 0
    q.put((keys[start].dist(keys[end]), keys[start]))

    while not q.empty():
        _, pos = q.get()

        if pos == keys[end]:
            return getPath()

        for next in pos.nearby():
            if next not in world:
                continue
            if next in fastest and fastest[pos] >= fastest[next] - 1:
                continue

            cameFrom[next] = pos
            fastest[next] = fastest[pos] + 1
            q.put((next.dist(keys[end]), next))


def dijkstra(world, keys, start='@'):
    fastest, paths = {}, {}

    q = queue.PriorityQueue()
    q.put((0, start, frozenset([start])))

    while not q.empty():
        steps, pos, keyring = q.get()

        for nextKey in (set(keys.keys()) - keyring):

            if (path := frozenset((pos, nextKey))) not in paths:
                paths[path] = astar(world, pos, nextKey)

            dist, doors = paths[path]
            dist += steps

            if any(d.lower() not in keyring for d in doors):
                continue

            nextKeyring = frozenset([nextKey]).union(keyring)
            state = (nextKey, nextKeyring)

            if state not in fastest or dist < fastest[state]:
                fastest[state] = dist
                q.put((dist, nextKey, nextKeyring))

    return min(fastest[x] for x in fastest if len(x[1]) == len(keys.keys()))

world, keys = {}, {}

with open("input/18.txt") as f:
    for y, line in enumerate(f.read().splitlines()):
        for x, c in enumerate(line):
            if c != '#':
                world[Position(y, x)] = c
            if c.islower() or c == '@':
                keys[c] = Position(y, x)

print(f"Silver: {dijkstra(world, keys)}")
