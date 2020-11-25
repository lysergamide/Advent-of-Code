# traveling salesman problem
from queue import PriorityQueue
from operator import sub
from collections import defaultdict
from itertools import (combinations, permutations)


def neighbors(node, maze):
    x, y = node
    neighbors = [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
    return list(filter(lambda x: x in maze and maze[x] < float('inf'), neighbors))


def AStar(start, goal, maze):
    def dist(a, b):
        # manhattan distance
        return sum(map(lambda x: abs(sub(*x)), (zip(a, b))))

    def buildPath(cameFrom, current):
        # return the shortest path
        path = [current]
        while current in cameFrom.keys():
            current = cameFrom[current]
            path.append(current)

        return path[::-1]

    pq = PriorityQueue()
    cameFrom = {}
    gScore = defaultdict(lambda: float('inf'))
    fScore = defaultdict(lambda: float('inf'))

    gScore[start] = 0
    fScore[start] = dist(start, goal)
    pq.put((fScore[start], start))

    while not pq.empty():
        _, current = pq.get()
        if current == goal:
            return buildPath(cameFrom, current)

        for n in neighbors(current, maze):
            tmpgScore = gScore[current] + 1

            if tmpgScore < gScore[n]:
                nDist = dist(n, goal)
                cameFrom[n] = current
                gScore[n] = tmpgScore
                fScore[n] = gScore[n] + nDist

                if (fScore[n], n) not in pq.queue:
                    pq.put((fScore[n], n))


def fastestPath(nums, start, subFast, part2=False):
    # find fastest route between any two nodes

    fastest = float('inf')

    for perm in permutations(nums):
        path = [start] + list(perm)  # + [start]
        if part2:
            path += [start]
        steps = 0
        for subPath in zip(path[:-1:], path[1::]):
            steps += subFast[subPath]
            if steps > fastest:
                break
        fastest = min(fastest, steps)

    return fastest


maze = {}
fastest = {}
nums = []
start = tuple()

# fill maze
for y, line in enumerate(open('input/24.txt').readlines()):
    # for y, line in enumerate(open('test').readlines()):
    for x, c in enumerate(line.strip()):
        pos = (x, y)
        if c == '.':
            maze[pos] = -1
        elif c == '#':
            maze[pos] = float('inf')
        else:
            maze[pos] = int(c)

# find position of numbers and starting place
for pos, val in maze.items():
    if val > -1 and val < float('inf'):
        if val != 0:
            nums.append(pos)
        else:
            start = pos

# find fastest route between any two nodes
for a, b in combinations(nums + [start], 2):
    distance = len(AStar(a, b, maze)) - 1
    fastest[(a, b)] = distance
    fastest[(b, a)] = distance


print(fastestPath(nums, start, fastest))
print(fastestPath(nums, start, fastest, part2=True))