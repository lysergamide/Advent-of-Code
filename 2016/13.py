from queue import PriorityQueue, Queue


def isOpen(x: int, y: int, magic: int) -> bool:
    # fast bit count from Hacker's Delight
    def countBits(x: int) -> int:
        ret = 0
        while x > 0:
            ret += 1
            x &= x - 1

        return ret

    return countBits(magic + (x*x + 3*x + 2*x*y + y + y*y)) % 2 == 0


def neighbors(pos):
    x, y = pos
    ret = [(x + 1, y), (x, y + 1)]
    if x > 0:
        ret.append((x - 1, y))
    if y > 0:
        ret.append((x, y - 1))

    return ret


def dist(p1, p2):
    return abs(p1[0] - p2[0]) + abs(p1[1] - p2[1])


def shortestPath(magic: int, dest=(31, 39), origin=(1, 1)) -> int:
    visited = set()
    q = PriorityQueue()
    fastest = float('inf')

    q.put((0, dist(origin, dest), origin))
    while not q.empty():
        steps, _, pos = q.get()

        if steps > fastest:
            continue
        if pos == dest:
            fastest = steps
            continue

        for n in filter(lambda x: x not in visited and isOpen(*x, magic), neighbors(pos)):
            q.put((steps + 1, dist(n, dest),  n))
            visited.add(n)

    return fastest


def flood(magic: int, origin=(1, 1)) -> int:
    ret = 0
    visited = set()
    q = Queue()
    q.put((50, origin))

    while not q.empty():
        steps, pos = q.get()

        if steps == 0:
            continue

        ret += 1
        for n in filter(lambda x: x not in visited and isOpen(*x, magic), neighbors(pos)):
            q.put((steps - 1, n))
            visited.add(n)

    return ret


magic = int(open("input/13.txt").read())
print(shortestPath(magic))
print(flood(magic))
